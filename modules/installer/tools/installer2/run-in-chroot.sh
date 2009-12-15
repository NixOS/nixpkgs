#!/bin/sh
# helper script preparing chroot by mounting /dev /proc /sys etc

set -e

usage(){
  cat << EOF
  $SCRIPT OPTS or cmd
  OPTS:
  --prepare    : only mount
  --unprepare  : only unmount
  --debug      : set -x

  requisites: perl

  $SCRIPT --prepare:   prepare chroot only
  $SCRIPT --unprepare: unprepare chroot only
  $SCRIPT command:     run /bin/sh command in chroot

  usage example run a shell in chroot:
    $SCRIPT path-to-sh

EOF
  exit 1
}

die(){ echo "!>> " $@; exit 1; }
INFO(){ echo "INFO: " $@; }

# this is no longer needed because umount -l unmounts rescursive --rbound mounts as well
#umountUnder() {
#    local dir="$1"
#    for i in $(grep -F " $dir" /proc/mounts \
#        | perl -e 'while (<>) { /^\S+\s+(\S+)\s+/; print "$1\n"; }' \
#        | sort -r);
#    do
#        echo umount $i || true
#    done
#}


prepare(){
  INFO "Enable networking: copying /etc/resolv.conf"
  mkdir -m 0755 -p $mountPoint/etc
  touch /etc/resolv.conf 
  cp /etc/resolv.conf $mountPoint/etc/

  INFO "mounting /proc /sys /dev and / to /host-system"
  mkdir -m 0755 -p $mountPoint/{dev,proc,sys,host-system}
  mount --bind /dev $mountPoint/dev
  mount --bind /proc $mountPoint/proc
  mount --bind /sys $mountPoint/sys
  mount --rbind / $mountPoint/host-system
}

unprepare(){
  INFO "unmounting /proc /sys /dev and removing /host-system if empty"
  for d in $mountPoint/{host-system,dev,proc,sys}; do
    umount -l "$d"
  done
  # no -fr !!
  rmdir $mountPoint/host-system
}

run_cmd(){
  prepare
  trap "unprepare" EXIT
  chroot $mountPoint $@
}


SCRIPT="$(basename "$0")"
mountPoint=${mountPoint:-/mnt}

[ -d $mountPoint ] || die "$mountPoint is not a directory"

while [ "$#" > 0 ]; do
  case $1 in

    --debug)     shift; set -x;;

    -h|--help)   shift; usage;;

    --prepare)   shift; prepare;;

    --unprepare) shift; unprepare;;

    *)
      run_cmd "$@"
      exit 0
    ;;
  esac
done
