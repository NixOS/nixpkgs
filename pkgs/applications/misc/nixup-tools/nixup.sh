#! @shell@

CONFIG_FILE=${XDG_CONFIG_HOME:-$HOME/.config}/nixup/packages.nix
PACKAGE_NAME=$package

ACTION=

while [[ "$#" -gt 0 ]]; do
    i="$1"; shift 1
    case "$i" in
      package)
        j="$1"; shift 1
        case "$j" in
          install|remove)
            ACTION="$i"-"$j"
            PACKAGE_NAME="$1"; shift 1
            ;;
          *)
            echo "$0: unknown option \`$j'"
            exit 1
            ;;
        esac
        ;;
      switch|build)
        ACTION="$i"
        ;;
      *)
        echo "$0: unknown command \`$i'"
        exit 1
        ;;
    esac
done

if [ "$ACTION" = "switch" ]; then
    ${NIXUP_API:?}/bin/nixup-rebuild switch
fi

if [ "$ACTION" = "build" ]; then
    ${NIXUP_API:?}/bin/nixup-rebuild build
fi

if [ "$ACTION" = "package-remove" ]; then
    if [[ -e $CONFIG_FILE ]]; then
        @gnused@/bin/sed -n "/^$PACKAGE_NAME\$/q 1" "$CONFIG_FILE"
        if [[ $? == 1 ]]; then
            echo "Removing $PACKAGE_NAME..."
            @gnused@/bin/sed -i "/^$PACKAGE_NAME\$/d" "$CONFIG_FILE"
            @gnused@/bin/sed -i '/^[[:space:]]*$/d' "$CONFIG_FILE"
            ${NIXUP_API:?}/bin/nixup-rebuild switch
        else
            echo "ERROR: $PACKAGE_NAME is not installed!"
            exit 1
        fi
    else
        echo "ERROR: $PACKAGE_NAME is not installed!"
        exit 1
    fi
fi


if [[ "$ACTION" = "package-install" ]]; then
    isAvailable=$(@nix@/bin/nix-instantiate --eval -E "builtins.hasAttr \"$PACKAGE_NAME\" (import <nixpkgs> {})")
    if [[ "$isAvailable" == "false" ]]; then
        echo "ERROR: Package is not available."
        exit 1
    fi
    if [[ -e $CONFIG_FILE ]]; then
        @gnused@/bin/sed -n "/^$PACKAGE_NAME\$/q 1" "$CONFIG_FILE"
        if [ $? == 0 ]; then
            echo "Installing $PACKAGE_NAME..."
            echo "$PACKAGE_NAME" >> "$CONFIG_FILE"
            @gnused@/bin/sed -i '/^[[:space:]]*$/d' "$CONFIG_FILE"
            ${NIXUP_API:?}/bin/nixup-rebuild switch
        else
            echo "WARNING: $PACKAGE_NAME is already installed!"
            exit 1
        fi
    else
        @coreutils@/bin/mkdir -p "$(dirname "$CONFIG_FILE")"
        echo "Installing $PACKAGE_NAME..."
        echo "$PACKAGE_NAME" > "$CONFIG_FILE"
        ${NIXUP_API:?}/bin/nixup-rebuild switch
    fi
fi
