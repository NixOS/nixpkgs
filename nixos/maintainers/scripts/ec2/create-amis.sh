#! /bin/sh -e

set -o pipefail
#set -x

stateDir=${TMPDIR:-/tmp}/ec2-image
echo "keeping state in $stateDir"
mkdir -p $stateDir

version=$(nix-instantiate --eval --strict '<nixpkgs>' -A lib.nixpkgsVersion | sed s/'"'//g)
major=${version:0:5}
echo "NixOS version is $version ($major)"

rm -f ec2-amis.nix


for type in hvm pv; do
    link=$stateDir/$type
    imageFile=$link/nixos.qcow2
    system=x86_64-linux
    arch=x86_64

    # Build the image.
    if ! [ -L $link ]; then
        if [ $type = pv ]; then hvmFlag=false; else hvmFlag=true; fi

        echo "building image type '$type'..."
        nix-build -o $link \
            '<nixpkgs/nixos>' \
            -A config.system.build.amazonImage \
            --arg configuration "{ imports = [ <nixpkgs/nixos/maintainers/scripts/ec2/amazon-image.nix> ]; ec2.hvm = $hvmFlag; }"
    fi

    for store in ebs s3; do

        bucket=nixos-amis
        bucketDir="$version-$type-$store"

        prevAmi=
        prevRegion=

        for region in eu-west-1 eu-central-1 us-east-1 us-west-1 us-west-2 ap-southeast-1 ap-southeast-2 ap-northeast-1 sa-east-1; do

            name=nixos-$version-$arch-$type-$store
            description="NixOS $system $version ($type-$store)"

            amiFile=$stateDir/$region.$type.$store.ami-id

            if ! [ -e $amiFile ]; then

                echo "doing $name in $region..."

                if [ -n "$prevAmi" ]; then
                    ami=$(ec2-copy-image \
                        --region "$region" \
                        --source-region "$prevRegion" --source-ami-id "$prevAmi" \
                        --name "$name" --description "$description" | cut -f 2)
                else

                    if [ $store = s3 ]; then

                        # Bundle the image.
                        imageDir=$stateDir/$type-bundled

                        # Convert the image to raw format.
                        rawFile=$stateDir/$type.raw
                        if ! [ -e $rawFile ]; then
                            qemu-img convert -f qcow2 -O raw $imageFile $rawFile.tmp
                            mv $rawFile.tmp $rawFile
                        fi

                        if ! [ -d $imageDir ]; then
                            rm -rf $imageDir.tmp
                            mkdir -p $imageDir.tmp
                            ec2-bundle-image \
                                -d $imageDir.tmp \
                                -i $rawFile --arch $arch \
                                --user "$AWS_ACCOUNT" -c "$EC2_CERT" -k "$EC2_PRIVATE_KEY"
                            mv $imageDir.tmp $imageDir
                        fi

                        # Upload the bundle to S3.
                        if ! [ -e $imageDir/uploaded ]; then
                            echo "uploading bundle to S3..."
                            ec2-upload-bundle \
                                -m $imageDir/$type.raw.manifest.xml \
                                -b "$bucket/$bucketDir" \
                                -a "$EC2_ACCESS_KEY" -s "$EC2_SECRET_KEY" \
                                --location EU
                            touch $imageDir/uploaded
                        fi

                        extraFlags="$bucket/$bucketDir/$type.raw.manifest.xml"

                    else

                        # Convert the image to vhd format so we don't have
                        # to upload a huge raw image.
                        vhdFile=$stateDir/$type.vhd
                        if ! [ -e $vhdFile ]; then
                            qemu-img convert -f qcow2 -O vpc $imageFile $vhdFile.tmp
                            mv $vhdFile.tmp $vhdFile
                        fi

                        taskId=$(cat $stateDir/$region.$type.task-id 2> /dev/null || true)
                        volId=$(cat $stateDir/$region.$type.vol-id 2> /dev/null || true)
                        snapId=$(cat $stateDir/$region.$type.snap-id 2> /dev/null || true)

                        # Import the VHD file.
                        if [ -z "$snapId" -a -z "$volId" -a -z "$taskId" ]; then
                            echo "importing $vhdFile..."
                            taskId=$(ec2-import-volume $vhdFile --no-upload -f vhd \
                                -o "$EC2_ACCESS_KEY" -w "$EC2_SECRET_KEY" \
                                --region "$region" -z "${region}a" \
                                --bucket "$bucket" --prefix "$bucketDir/" \
                                | tee /dev/stderr \
                                | sed 's/.*\(import-vol-[0-9a-z]\+\).*/\1/ ; t ; d')
                            echo -n "$taskId" > $stateDir/$region.$type.task-id
                        fi

                        if [ -z "$snapId" -a -z "$volId" ]; then
                            ec2-resume-import  $vhdFile -t "$taskId" --region "$region" \
                                -o "$EC2_ACCESS_KEY" -w "$EC2_SECRET_KEY"
                        fi

                        # Wait for the volume creation to finish.
                        if [ -z "$snapId" -a -z "$volId" ]; then
                            echo "waiting for import to finish..."
                            while true; do
                                volId=$(ec2-describe-conversion-tasks "$taskId" --region "$region" | sed 's/.*VolumeId.*\(vol-[0-9a-f]\+\).*/\1/ ; t ; d')
                                if [ -n "$volId" ]; then break; fi
                                sleep 10
                            done

                            echo -n "$volId" > $stateDir/$region.$type.vol-id
                        fi

                        # Delete the import task.
                        if [ -n "$volId" -a -n "$taskId" ]; then
                            echo "removing import task..."
                            ec2-delete-disk-image -t "$taskId" --region "$region" -o "$EC2_ACCESS_KEY" -w "$EC2_SECRET_KEY" || true
                            rm -f $stateDir/$region.$type.task-id
                        fi

                        # Create a snapshot.
                        if [ -z "$snapId" ]; then
                            echo "creating snapshot..."
                            snapId=$(ec2-create-snapshot "$volId" --region "$region" | cut -f 2)
                            echo -n "$snapId" > $stateDir/$region.$type.snap-id
                            ec2-create-tags "$snapId" -t "Name=$description" --region "$region"
                        fi

                        # Wait for the snapshot to finish.
                        echo "waiting for snapshot to finish..."
                        while true; do
                            status=$(ec2-describe-snapshots "$snapId" --region "$region" | head -n1 | cut -f 4)
                            if [ "$status" = completed ]; then break; fi
                            sleep 10
                        done

                        # Delete the volume.
                        if [ -n "$volId" ]; then
                            echo "deleting volume..."
                            ec2-delete-volume "$volId" --region "$region" || true
                            rm -f $stateDir/$region.$type.vol-id
                        fi

                        extraFlags="-b /dev/sda1=$snapId:20:true:gp2"

                        if [ $type = pv ]; then
                            extraFlags+=" --root-device-name=/dev/sda1"
                        fi

                        extraFlags+=" -b /dev/sdb=ephemeral0 -b /dev/sdc=ephemeral1 -b /dev/sdd=ephemeral2 -b /dev/sde=ephemeral3"
                    fi

                    # Register the AMI.
                    if [ $type = pv ]; then
                        kernel=$(ec2-describe-images -o amazon --filter "manifest-location=*pv-grub-hd0_1.04-$arch*" --region "$region" | cut -f 2)
                        [ -n "$kernel" ]
                        echo "using PV-GRUB kernel $kernel"
                        extraFlags+=" --virtualization-type paravirtual --kernel $kernel"
                    else
                        extraFlags+=" --virtualization-type hvm"
                    fi

                    ami=$(ec2-register \
                        -n "$name" \
                        -d "$description" \
                        --region "$region" \
                        --architecture "$arch" \
                        $extraFlags | cut -f 2)
                fi

                echo -n "$ami" > $amiFile
                echo "created AMI $ami of type '$type' in $region..."

            else
                ami=$(cat $amiFile)
            fi

            if [ -z "$NO_WAIT" -o -z "$prevAmi" ]; then
                echo "waiting for AMI..."
                while true; do
                    status=$(ec2-describe-images "$ami" --region "$region" | head -n1 | cut -f 5)
                    if [ "$status" = available ]; then break; fi
                    sleep 10
                done

                ec2-modify-image-attribute \
                    --region "$region" "$ami" -l -a all
            fi

            echo "region = $region, type = $type, store = $store, ami = $ami"
            if [ -z "$prevAmi" ]; then
                prevAmi="$ami"
                prevRegion="$region"
            fi

            echo "  \"$major\".$region.$type-$store = \"$ami\";" >> ec2-amis.nix
        done

    done

done
