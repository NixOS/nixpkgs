#! /bin/sh -e

nixos=$(nix-instantiate --find-file nixos)
export NIXOS_CONFIG=$nixos/modules/virtualisation/amazon-config.nix

version=$(nix-instantiate --eval-only '<nixos>' -A config.system.nixosVersion | sed s/'"'//g)
echo "NixOS version is $version"

buildAndUploadFor() {
    system="$1"
    arch="$2"

    echo "building $system image..."
    nix-build '<nixos>' \
        -A config.system.build.amazonImage --argstr system "$system" -o ec2-ami

    ec2-bundle-image -i ./ec2-ami/nixos.img --user "$AWS_ACCOUNT" --arch "$arch" \
        -c "$EC2_CERT" -k "$EC2_PRIVATE_KEY"

    for region in eu-west-1 us-east-1 us-west-1 us-west-2; do
        echo "uploading $system image for $region..."

        name=nixos-$version-$arch-s3
        bucket="$(echo $name-$region | tr '[A-Z]_' '[a-z]-')"

        if [ "$region" = eu-west-1 ]; then s3location=EU;
        elif [ "$region" = us-east-1 ]; then s3location=US;
        else s3location="$region"
        fi

        ec2-upload-bundle -b "$bucket" -m /tmp/nixos.img.manifest.xml \
            -a "$EC2_ACCESS_KEY" -s "$EC2_SECRET_KEY" --location "$s3location" \
            --url http://s3.amazonaws.com

        kernel=$(ec2-describe-images -o amazon --filter "manifest-location=*pv-grub-hd0_1.03-$arch*" --region "$region" | cut -f 2)
        echo "using PV-GRUB kernel $kernel"

        ami=$(ec2-register "$bucket/nixos.img.manifest.xml" -n "$name" -d "NixOS $system r$revision" \
            --region "$region" --kernel "$kernel" | cut -f 2)

        echo "AMI ID is $ami"

        echo $ami >> $region.s3.ami-id

        ec2-modify-image-attribute --region "$region" "$ami" -l -a all
    done
}

buildAndUploadFor x86_64-linux x86_64
