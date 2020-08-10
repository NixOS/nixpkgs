#!/usr/bin/env bash

####################################################
# AZ LOGIN CHECK                                   #
####################################################

# Making  sure  that  one   is  logged  in  (to  avoid
# surprises down the line).
# TODO Works flawlessly when  not logged in, but shows
#      error when do logged in.
#      > ./upload-image.sh: line 126: [: too many arguments
if [ $(az account list 2> /dev/null) = [] ]
then
  echo
  echo '********************************************************'
  echo '* Please log  in to  Azure by  typing "az  login", and *'
  echo '* repeat the "./upload-image.sh" command.              *'
  echo '********************************************************'
  exit 1
fi

####################################################
# HELPERS                                          #
####################################################

show_id() {
  az $1 show \
    --resource-group "${resource_group}" \
    --name "${img_name}"        \
    --query "[id]"              \
    --output tsv
}

# make_boot_sh_opts <image-id> "<opt1>=<val1>;...;<optn>=<valn>"
make_boot_sh_opts() {
  # Add `./upload-image.sh`'s resource group if not given
  # https://stackoverflow.com/a/8811800/1498178 (contains string?)
  if [ "${2#*g=}" != "$2" ] || [ "${2#*resource-group}" != "$2" ]
  then
    opt_string=$2
  else
    opt_string="resource-group=${resource_group};$2"
  fi

  acc=""
  # https://stackoverflow.com/a/918931/1498178 (parse and loop opt-string)
  while IFS=';' read -ra opts; do
    for i in "${opts[@]}"; do
        # https://stackoverflow.com/a/10520718/1498178 (separate opts and vals)
        opt=${i%=*}
        val=${i#*=}
        # https://stackoverflow.com/a/17750975/1498178 (string length)
        # https://stackoverflow.com/a/3953712/1498178 (ternary)
        sep=$([ ${#opt} == 1 ] && echo "-" || echo "--")
        acc="${acc}${sep}${opt} ${val} "
    done
  done <<< "image=$1;$opt_string"

  echo $acc
}

usage() {
  echo ''
  echo 'USAGE: (Every switch requires an argument)'
  echo ''
  echo '-g --resource-group REQUIRED Created if does  not exist. Will'
  echo '                             house a new disk and the created'
  echo '                             image.'
  echo ''
  echo '-n --image-name     REQUIRED The  name of  the image  created'
  echo '                             (and also of the new disk).'
  echo ''
  echo '-i --image-nix      Nix  expression   to  build  the'
  echo '                    image. Default value:'
  echo '                    "./examples/basic/image.nix".'
  echo ''
  echo '-l --location       Values from `az account list-locations`.'
  echo '                    Default value: "westus2".'
  echo ''
  echo '-b --boot-sh-opts   Once  the image  is created  and uploaded,'
  echo '                    run `./boot-vm.sh`  with arguments  in the'
  echo '                    format of "opt1=val1;...;optn=valn".'
  echo ''
  echo '                    + "vm-name=..." (or "n=...") is mandatory'
  echo ''
  echo '                    + "--image" will  be  pre-populated  with'
  echo "                      the created image's ID"
  echo ''
  echo '                    + if  resource group  is omitted,  the one'
  echo '                      for `./upload-image.sh` is used'
}

####################################################
# SWITCHES                                         #
####################################################

# https://unix.stackexchange.com/a/204927/85131
while [ $# -gt 0 ]; do
  case "$1" in
    -i|--image-nix)
      image_nix="$2"
      ;;
    -l|--location)
      location="$2"
      ;;
    -g|--resource-group)
      resource_group="$2"
      ;;
    -n|--image-name)
      img_name="$2"
      ;;
    -b|--boot-sh-opts)
      boot_opts="$2"
      ;;
    -h|--help)
      usage
      exit 1
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument *\n"
      printf "***************************\n"
      usage
      exit 1
  esac
  shift
  shift
done

if [ -z "${img_name}" ] || [ -z "${resource_group}" ]
then
  printf "************************************\n"
  printf "* Error: Missing required argument *\n"
  printf "************************************\n"
  usage
  exit 1
fi

####################################################
# DEFAULTS                                         #
####################################################

image_nix_d="${image_nix:-"./examples/basic/image.nix"}"
location_d="${location:-"westus2"}"
boot_opts_d="${boot_opts:-"none"}"

####################################################
# PUT IMAGE INTO AZURE CLOUD                       #
####################################################

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

nix-build             \
  --out-link "azure"  \
  "${image_nix_d}"

# Make resource group exists
if ! az group show --resource-group "${resource_group}" &>/dev/null
then
  az group create     \
    --name "${resource_group}" \
    --location "${location_d}"
fi

# NOTE: The  disk   access  token   song/dance  is
#       tedious  but allows  us  to upload  direct
#       to  a  disk  image thereby  avoid  storage
#       accounts (and naming them) entirely!

if ! show_id "disk" &>/dev/null
then

  img_file="$(readlink -f ./azure/disk.vhd)"
  bytes="$(stat -c %s ${img_file})"

  az disk create                \
    --resource-group "${resource_group}" \
    --name "${img_name}"        \
    --for-upload true           \
    --upload-size-bytes "${bytes}"

  timeout=$(( 60 * 60 )) # disk access token timeout
  sasurl="$(\
    az disk grant-access               \
      --access-level Write             \
      --resource-group "${resource_group}"      \
      --name "${img_name}"             \
      --duration-in-seconds ${timeout} \
      --query "[accessSas]"            \
      --output tsv
  )"

  azcopy copy "${img_file}" "${sasurl}" \
    --blob-type PageBlob

  # https://docs.microsoft.com/en-us/cli/azure/disk?view=azure-cli-latest#az-disk-revoke-access
  # > Revoking the SAS will  change the state of
  # > the managed  disk and allow you  to attach
  # > the disk to a VM.
  az disk revoke-access         \
    --resource-group "${resource_group}" \
    --name "${img_name}"
fi

if ! show_id "image" &>/dev/null
then

  az image create                \
    --resource-group "${resource_group}"  \
    --name "${img_name}"         \
    --source "$(show_id "disk")" \
    --os-type "linux" >/dev/null
fi

if [ "${boot_opts_d}" != "none" ]
then
  img_id="$(show_id "image")"
  ./boot-vm.sh $(make_boot_sh_opts $img_id $boot_opts_d)
fi
