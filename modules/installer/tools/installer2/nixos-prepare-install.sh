#!/bin/sh

# prepare installation by putting in place unless present:
# /etc/nixos/nixpkgs
# /etc/nixos/nixos
# /etc/nixos/configuration.nix


set -e

usage(){
  cat << EOF
  script options [list of actions]

  actions:

    guess-config:     run nixos-hardware-scan > T/configuration.nix
    copy-nix:         copy minimal nix system which can bootstrap the whole system
                      This creates the $mountPoint/bin/sh symlink
                      If you're bootstrapping from an archive store paths are registered valid only
    copy-nixos-bootstrap:
                      copy the nixos-bootstrap script to /nix/store where it will be
                      garbage collected later
    copy-sources:     copy repos   into T/
    checkout-sources: svn checkout official repos into T/


    where T=$T
      and repos = $ALL_REPOS

  options:
    --force: If targets exist no action will taken unless you use --force
             in which case target is renamed before action is run
    --dir-ok: allow installing into directory (omits is mount point check)

    --debug: set -x


  default list of actions: $DEFAULTS
EOF
  exit 1
}


INFO(){ echo "INFO: " $@; }

# = configuration =

FORCE_ACTIONS=${FORCE_ACTIONS:-}
ALL_REPOS="nixpkgs nixos"
mountPoint=${mountPoint:-/mnt}

if [ -e $mountPoint/README-BOOTSTRAP-NIXOS ]; then
  INFO "$mountPoint/README-BOOTSTRAP-NIXOS found, assuming your're bootstrapping from an archive. Nix files should be in place"
  FROM_ARCHIVE=1
  DEFAULTS="guess-config copy-nix"
else
  FROM_ARCHIVE=0
  DEFAULTS="guess-config copy-nixos-bootstrap copy-nix copy-sources"
fi

backupTimestamp=$(date "+%Y%m%d%H%M%S")
SRC_BASE=${SRC_BASE:-"/etc/nixos"}
SVN_BASE="https://svn.nixos.org/repos/nix"
MUST_BE_MOUNTPOINT=${MUST_BE_MOUNTPOINT:-1}
T="$mountPoint/etc/nixos"

NIX_CLOSURE=${NIX_CLOSURE:-@nixClosure@}

die(){ echo "!>> " $@; exit 1; }

## = read options =
# actions is used by main loop at the end
ACTIONS=""
# check and handle options:
for a in $@; do
  case "$a" in
    copy-nix|copy-nixos-bootstrap|guess-config|copy-sources|checkout-sources)
      ACTIONS="$ACTIONS $a"
    ;;
    --dir-ok)
      MUST_BE_MOUNTPOINT=false
    ;;
    --force)
      FORCE_ACTIONS=1
    ;;
    --debug)
      set -x
    ;;
    *)
      echo "unkown option: $a"
      usage
    ;;
  esac
done
[ -n "$ACTIONS" ] || ACTIONS="$DEFAULTS"


if ! grep -F -q " $mountPoint " /proc/mounts && [ "$MUST_BE_MOUNTPOINT" = 1 ]; then
    die "$mountPoint doesn't appear to be a mount point"
fi

# = utils =

backup(){
  local dst="$(dirname "$1")/$(basename "$1")-$backupTimestamp"
  INFO "backing up: $1 -> $dst"
  mv "$1" "$dst"
}

# = implementation =

# exit status  = 0: target exists
# exti status != 0: target must be rebuild either because --force was given or
#                   because it didn't exist yet
target_realised(){
  if [ -e "$1" ] && [ "$FORCE_ACTIONS" = 1 ]; then
      backup "$1"
  fi

  [ -e "$1" ] && {
    INFO "not realsing $1. Target already exists. Use --force to force."
  }
}

createDirs(){
  mkdir -m 0755 -p $mountPoint/etc/nixos
  mkdir -m 1777 -p $mountPoint/nix/store
}


realise_repo(){
  local action=$1
  local repo=$2

  createDirs

  if [ "$action" == "copy-sources" ]; then

    local repo_sources="${repo}_SOURCES"
    rsync -a -r "${SRC_BASE}/$repo" "$T"

  else

    INFO "checking out $repo"
    svn co "$SVN_BASE/$repo/trunk" "$T/$repo"

  fi

}

# only keep /nix/store/* lines
# print them only once
pathsFromGraph(){
  declare -A a
  local prefix=/nix/store/
  while read l; do
    if [ "${l/#$prefix/}" != "$l" ] && [ -z "${a["$l"]}" ]; then
      echo "$l";
      a["$l"]=1;
    fi
  done
}

# = run actions: =
for a in $ACTIONS; do
  case "$a" in

    guess_config)
      local config="$T/configuration.nix"
      target_realised "$config" || {
        INFO "creating simple configuration file"
        nixos-hardware-scan > "$config"
        echo
        INFO "Note: you can start customizing $config while remaining actions will are being executed"
        echo
      }
    ;;

    copy-nixos-bootstrap)
      createDirs
      # this script will be garbage collected somewhen:
      cp @nixosBootstrap@/bin/nixos-bootstrap $mountPoint/nix/store/
    ;;

    copy-nix)
      if [ "$FROM_ARCHIVE" = 1 ]; then
        NIX_CLOSURE=${mountPoint}@nixClosure@
      else
        INFO "Copy Nix to the Nix store on the target device."
        createDirs
        echo "copying Nix to $mountPoint...."

        for i in `cat $NIX_CLOSURE | pathsFromGraph`; do
            echo "  $i"
            rsync -a $i $mountPoint/nix/store/
        done

      fi

      [ -e "$NIX_CLOSURE" ] || die "Couldn't find nixClosure $NIX_CLOSURE anywhere. Can't register inital store paths valid. Exiting"

      # Create the required /bin/sh symlink; otherwise lots of things
      # (notably the system() function) won't work.
      mkdir -m 0755 -p $mountPoint/bin
      ln -sf @shell@ $mountPoint/bin/sh

      INFO "registering bootstrapping store paths as valid so that they won't be rebuild"
      # Register the paths in the Nix closure as valid.  This is necessary
      # to prevent them from being deleted the first time we install
      # something.  (I.e., Nix will see that, e.g., the glibc path is not
      # valid, delete it to get it out of the way, but as a result nothing
      # will work anymore.)
      # TODO: check permissions so that paths can't be changed later?
      chroot "$mountPoint" @nix@/bin/nix-store --register-validity < $NIX_CLOSURE

    ;;

    copy-sources|checkout-sources)

      for repo in $ALL_REPOS; do
        target_realised "$T/$repo" || realise_repo $a $repo
      done

    ;;
  esac
done

if [ -e "$T/nixos" ] && [ -e "$T/nixpkgs" ] && [ -e "$T/configuration.nix" ]; then
  cat << EOF
    To realise your NixOS installtion execute:

    run-in-chroot "/nix/store/nixos-bootstrap --install -j2 --keep-going"
EOF
else
  for t in "$T/configuration.nix" "$T/nixpkgs" "$T/configuration.nix"; do
    INFO "you can't start because $t is missing"
  done
fi
