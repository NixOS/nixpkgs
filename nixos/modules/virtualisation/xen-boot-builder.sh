# This script is called by ./xen-dom0.nix to create the Xen boot entries.
# shellcheck shell=bash

# Handle input argument and exit if the flag is invalid. See virtualisation.xen.efi.bootBuilderVerbosity below.
[[ $# -ne 1 ]] && echo -e "\e[1;31merror:\e[0m xenBootBuilder must be called with exactly one verbosity argument. See the \e[1;34mvirtualisation.xen.efi.bootBuilderVerbosity\e[0m option." && exit 1
case "$1" in
    "quiet") true ;;
    "default" | "info") echo -n "Installing Xen Hypervisor boot entries..." ;;
    "debug") echo -e "\e[1;34mxenBootBuilder:\e[0m called with the '$1' flag" ;;
    *)
        echo -e "\e[1;31merror:\e[0m xenBootBuilder was called with an invalid argument. See the \e[1;34mvirtualisation.xen.efi.bootBuilderVerbosity\e[0m option."
        exit 2
        ;;
esac

# Get the current Xen generations and store them in an array. This will be used
# for displaying the diff later, if xenBootBuilder was called with `info`.
# We also delete the current Xen entries here, as they'll be rebuilt later if
# the corresponding NixOS generation still exists.
mapfile -t preGenerations < <(find "$efiMountPoint"/loader/entries -type f -name 'xen-*.conf' | sort -V | sed 's_/loader/entries/nixos_/loader/entries/xen_g;s_^.*/xen_xen_g;s_.conf$__g')
if [ "$1" = "debug" ]; then
    if ((${#preGenerations[@]} == 0)); then
        echo -e "\e[1;34mxenBootBuilder:\e[0m no previous Xen entries."
    else
        echo -e "\e[1;34mxenBootBuilder:\e[0m deleting the following stale xen entries:" && for debugGen in "${preGenerations[@]}"; do echo "                - $debugGen"; done
    fi
fi

# Cleanup all Xen entries.
rm -f "$efiMountPoint"/{loader/entries/xen-*.conf,efi/nixos/xen-*.efi}

# Main array for storing which generations exist in $efiMountPoint after
# systemd-boot-builder.py builds the main entries.
mapfile -t gens < <(find "$efiMountPoint"/loader/entries -type f -name 'nixos-*.conf' | sort -V)
[ "$1" = "debug" ] && echo -e "\e[1;34mxenBootBuilder:\e[0m found the following NixOS boot entries:" && for debugGen in "${gens[@]}"; do echo "                - $debugGen"; done

# This is the main loop that installs the Xen entries.
for gen in "${gens[@]}"; do

    # We discover the path to Bootspec through the init attribute in the entries,
    # as it is equivalent to $toplevel/init.
    bootspecFile="$(sed -nr 's/^options init=(.*)\/init.*$/\1/p' "$gen")/boot.json"
    [ "$1" = "debug" ] && echo -e "\e[1;34mxenBootBuilder:\e[0m processing bootspec file $bootspecFile"

    # We do nothing if the Bootspec for the current $gen does not contain the Xen
    # extension, which is added as a configuration attribute below.
    if grep -sq '"org.xenproject.bootspec.v1"' "$bootspecFile"; then
        [ "$1" = "debug" ] && echo -e "                \e[1;32msuccess:\e[0m found Xen entries in $gen."

        # TODO: Support DeviceTree booting. Xen has some special handling for DeviceTree
        # attributes, which will need to be translated in a boot script similar to this
        # one. Having a DeviceTree entry is rare, and it is not always required for a
        # successful boot, so we don't fail here, only warn with `debug`.
        if grep -sq '"devicetree"' "$bootspecFile"; then
            echo -e "\n\e[1;33mwarning:\e[0m $gen has a \e[1;34morg.nixos.systemd-boot.devicetree\e[0m Bootspec entry. Xen currently does not support DeviceTree, so this value will be ignored in the Xen boot entries, which may cause them to \e[1;31mfail to boot\e[0m."
        else
            [ "$1" = "debug" ] && echo -e "\e[1;34mxenBootBuilder:\e[0m no DeviceTree entries found in $gen."
        fi

        # Prepare required attributes for `xen.cfg/xen.conf`. It inherits the name of
        # the corresponding nixos generation, substituting `nixos` with `xen`:
        # `xen-$profile-generation-$number-specialisation-$specialisation.{cfg,conf}`
        xenGen=$(echo "$gen" | sed 's_/loader/entries/nixos_/loader/entries/xen_g;s_^.*/xen_xen_g;s_.conf$__g')
        bootParams=$(jq -re '."org.xenproject.bootspec.v1".xenParams | join(" ")' "$bootspecFile")
        kernel=$(jq -re '."org.nixos.bootspec.v1".kernel | sub("^/nix/store/"; "") | sub("/bzImage"; "-bzImage.efi")' "$bootspecFile")
        kernelParams=$(jq -re '."org.nixos.bootspec.v1".kernelParams | join(" ")' "$bootspecFile")
        initrd=$(jq -re '."org.nixos.bootspec.v1".initrd | sub("^/nix/store/"; "") | sub("/initrd"; "-initrd.efi")' "$bootspecFile")
        init=$(jq -re '."org.nixos.bootspec.v1".init' "$bootspecFile")
        title=$(sed -nr 's/^title (.*)$/\1/p' "$gen")
        version=$(sed -nr 's/^version (.*)$/\1/p' "$gen")
        machineID=$(sed -nr 's/^machine-id (.*)$/\1/p' "$gen")
        sortKey=$(sed -nr 's/^sort-key (.*)$/\1/p' "$gen")

        # Write `xen.cfg` to a temporary location prior to UKI creation.
        tmpCfg=$(mktemp)
        [ "$1" = "debug" ] && echo -ne "\e[1;34mxenBootBuilder:\e[0m writing $xenGen.cfg to temporary file..."
        cat > "$tmpCfg" << EOF
[global]
default=xen

[xen]
options=$bootParams
kernel=$kernel init=$init $kernelParams
ramdisk=$initrd
EOF
        [ "$1" = "debug" ] && echo -e "done."

        # Create Xen UKI for $generation. Most of this is lifted from
        # https://xenbits.xenproject.org/docs/unstable/misc/efi.html.
        [ "$1" = "debug" ] && echo -e "\e[1;34mxenBootBuilder:\e[0m making Xen UKI..."
        xenEfi=$(jq -re '."org.xenproject.bootspec.v1".xen' "$bootspecFile")
        padding=$(objdump --header --section=".pad" "$xenEfi" | awk '/\.pad/ { printf("0x%016x\n", strtonum("0x"$3) + strtonum("0x"$4))};')
        [ "$1" = "debug" ] && echo "               - padding: $padding"
        objcopy \
            --add-section .config="$tmpCfg" \
            --change-section-vma .config="$padding" \
            "$xenEfi" \
            "$efiMountPoint"/EFI/nixos/"$xenGen".efi
        [ "$1" = "debug" ] && echo -e "               - \e[1;32msuccessfully built\e[0m $xenGen.efi"
        rm -f "$tmpCfg"

        # Write `xen.conf`.
        [ "$1" = "debug" ] && echo -ne "\e[1;34mxenBootBuilder:\e[0m writing $xenGen.conf to EFI System Partition..."
        cat > "$efiMountPoint"/loader/entries/"$xenGen".conf << EOF
title $title (with Xen Hypervisor)
version $version
efi /EFI/nixos/$xenGen.efi
machine-id $machineID
sort-key $sortKey
EOF
        [ "$1" = "debug" ] && echo -e "done."

    # Sometimes, garbage collection weirdness causes a generation to still exist in
    # the loader entries, but its Bootspec file was deleted. We consider such a
    # generation to be invalid, but we don't write extra code to handle this
    # situation, as supressing grep's error messages above is quite enough, and the
    # error message below is still technically correct, as no Xen can be found in
    # something that does not exist.
    else
        [ "$1" = "debug" ] && echo -e "                \e[1;33mwarning:\e[0m \e[1;31mno Xen found\e[0m in $gen."
    fi
done

# Counterpart to the preGenerations array above. We use it to diff the
# generations created/deleted when callled with the `info` argument.
mapfile -t postGenerations < <(find "$efiMountPoint"/loader/entries -type f -name 'xen-*.conf' | sort -V | sed 's_/loader/entries/nixos_/loader/entries/xen_g;s_^.*/xen_xen_g;s_.conf$__g')

# In the event the script does nothing, guide the user to debug, as it'll only
# ever run when Xen is enabled, and it makes no sense to enable Xen and not have
# any hypervisor boot entries.
if ((${#postGenerations[@]} == 0)); then
    case "$1" in
        "default" | "info") echo "none found." && echo -e "If you believe this is an error, set the \e[1;34mvirtualisation.xen.efi.bootBuilderVerbosity\e[0m option to \e[1;34m\"debug\"\e[0m and rebuild to print debug logs." ;;
        "debug") echo -e "\e[1;34mxenBootBuilder:\e[0m wrote \e[1;31mno generations\e[0m. Most likely, there were no generations with a valid \e[1;34morg.xenproject.bootspec.v1\e[0m entry." ;;
    esac

# If the script is successful, change the default boot, say "done.", write a
# diff, or print the total files written, depending on the argument this script
# was called with. We use some dumb dependencies here, like `diff` or `bat` for
# colourisation, but they're only included  with the `info` argument.
#
# It's also fine to change the default here, as this runs after the
# `systemd-boot-builder.py` script, which overwrites the file, and this script
# does not run after an user disables the Xen module.
else
    sed --in-place 's/^default nixos-/default xen-/g' "$efiMountPoint"/loader/loader.conf
    case "$1" in
        "default" | "info") echo "done." ;;
        "debug") echo -e "\e[1;34mxenBootBuilder:\e[0m \e[1;32msuccessfully wrote\e[0m the following generations:" && for debugGen in "${postGenerations[@]}"; do echo "                - $debugGen"; done ;;
    esac
    if [ "$1" = "info" ]; then
        if [[ ${#preGenerations[@]} == "${#postGenerations[@]}" ]]; then
            echo -e "\e[1;33mNo Change:\e[0m Xen Hypervisor boot entries were refreshed, but their contents are identical."
        else
            echo -e "\e[1;32mSuccess:\e[0m Changed the following boot entries:"
            # We briefly unset errexit and pipefail here, as GNU diff has no option to not fail when files differ.
            set +o errexit
            set +o pipefail
            diff <(echo "${preGenerations[*]}" | tr ' ' '\n') <(echo "${postGenerations[*]}" | tr ' ' '\n') -U 0 | grep --invert-match --extended-regexp '^(@@|---|\+\+\+).*' | sed '1{/^-$/d}' | bat --language diff --theme ansi --paging=never --plain
            true
            set -o errexit
            set -o pipefail
        fi
    fi
fi
