#! @bash@/bin/sh -e

shopt -s nullglob

export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin; done

if test $# -ne 1; then
    echo "Usage: init-script-builder.sh DEFAULT-CONFIG"
    exit 1
fi

defaultConfig="$1"


[ "$(stat -f -c '%i' /)" = "$(stat -f -c '%i' /boot)" ] || {
  # see grub-menu-builder.sh
  echo "WARNING: /boot being on a different filesystem not supported by init-script-builder.sh"
}



target="/sbin/init"
targetOther="/boot/init-other-configurations-contents.txt"

tmp="$target.tmp"
tmpOther="$targetOther.tmp"


configurationCounter=0
numAlienEntries=`cat <<EOF | egrep '^[[:space:]]*title' | wc -l
@extraEntries@
EOF`




# Add an entry to $targetOther
addEntry() {
    local name="$1"
    local path="$2"
    local shortSuffix="$3"

    configurationCounter=$((configurationCounter + 1))

    local stage2=$path/init

    content="$(
      echo "#!/bin/sh"
      echo "# $name"
      echo "# created by init-script-builder.sh"
      echo "export systemConfig=$(readlink -f $path)"
      echo "exec $stage2"
    )"

    [ "$path" != "$defaultConfig" ] || { 
      echo "$content" > $tmp
      echo "# older configurations: $targetOther" >> $tmp
      chmod +x $tmp
    }

    echo -e "$content\n\n" >> $tmpOther
}


mkdir -p /boot /sbin

addEntry "NixOS - Default" $defaultConfig ""

# Add all generations of the system profile to the menu, in reverse
# (most recent to least recent) order.
for link in $((ls -d $defaultConfig/fine-tune/* ) | sort -n); do
    date=$(stat --printf="%y\n" $link | sed 's/\..*//')
    addEntry "NixOS - variation" $link ""
done

for generation in $(
    (cd /nix/var/nix/profiles && ls -d system-*-link) \
    | sed 's/system-\([0-9]\+\)-link/\1/' \
    | sort -n -r); do
    link=/nix/var/nix/profiles/system-$generation-link
    date=$(stat --printf="%y\n" $link | sed 's/\..*//')
    if [ -d $link/kernel ]; then
      kernelVersion=$(cd $(dirname $(readlink -f $link/kernel))/lib/modules && echo *)
      suffix="($date - $kernelVersion)"
    else
      suffix="($date)"
    fi
    addEntry "NixOS - Configuration $generation $suffix" $link "$generation ($date)"
done

mv $tmpOther $targetOther
mv $tmp $target
