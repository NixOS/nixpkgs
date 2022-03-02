#!/usr/bin/env bash
fixupOutputHooks+=('convertDesktopFiles $prefix')

# Get a param out of a desktop file. First parameter is the file and the second
# is a pattern of the key who's value we should fetch.
getDesktopParam() {
    local file="$1";
    local pattern="$2";

    awk -F "=" "/${pattern}/ {print \$2}" "${file}"
}

# Convert a freedesktop.org icon theme for a given app to a .icns file. When possible, missing
# icons are synthesized from SVG or rescaled from existing ones (when within the size threshold).
convertIconTheme() {
    local -r out=$1
    local -r sharePath=$2
    local -r iconName=$3
    local -r theme=${4:-hicolor}

    local -ra iconSizes=(16 32 48 128 256 512)
    local -ra scales=([1]="" [2]="@2")

    # Based loosely on the algorithm at:
    # https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html#icon_lookup
    # Assumes threshold = 2 for ease of implementation.
    function findIcon() {
        local -r iconSize=$1
        local -r scale=$2

        local scaleSuffix=${scales[$scale]}
        local exactSize=${iconSize}x${iconSize}${scaleSuffix}

        if [[ $exactSize = '48x48@2' ]]; then
            # macOS does not support a 2x scale variant of 48x48 icons
            # See: https://en.wikipedia.org/wiki/Apple_Icon_Image_format#Icon_types
            echo "unsupported"
            return 0
        fi

        local -a validSizes=(
            ${exactSize}
            $((iconSize + 1))x$((iconSize + 1))${scaleSuffix}
            $((iconSize + 2))x$((iconSize + 2))${scaleSuffix}
            $((iconSize - 1))x$((iconSize - 1))${scaleSuffix}
            $((iconSize - 2))x$((iconSize - 2))${scaleSuffix}
        )

        for iconIndex in "${!candidateIcons[@]}"; do
            for maybeSize in "${validSizes[@]}"; do
                icon=${candidateIcons[$iconIndex]}
                if [[ $icon = */$maybeSize/* ]]; then
                    if [[ $maybeSize = $exactSize ]]; then
                        echo "fixed $icon"
                    else
                        echo "threshold $icon"
                    fi
                    return 0
                fi
            done
        done
        echo "scalable"
    }

    function resizeIcon() {
        local -r in=$1
        local -r out=$2
        local -r iconSize=$3
        local -r scale=$4

        local density=$((72 * scale))x$((72 * scale))
        local dim=$((iconSize * scale))

        magick convert -scale "${dim}x${dim}" -density "$density" -units PixelsPerInch "$in" "$out"
    }

    function synthesizeIcon() {
        local -r in=$1
        local -r out=$2
        local -r iconSize=$3
        local -r scale=$4

        if [[ $in != '-' ]]; then
            local density=$((72 * scale))x$((72 * scale))
            local dim=$((iconSize * scale))
            rsvg-convert --keep-aspect-ratio --width "$dim" --height "$dim" "$in" --output "$out"
            magick convert -density "$density" -units PixelsPerInch "$out" "$out"
        else
            return 1
        fi
    }

    function getIcons() {
        local -r sharePath=$1
        local -r iconname=$2
        local -r theme=$3
        local -r resultdir=$(mktemp -d)

        local -ar candidateIcons=(
            "${sharePath}/icons/${theme}/"*"/${iconname}.png"
            "${sharePath}/icons/${theme}/"*"/${iconname}.xpm"
        )

        local -a scalableIcon=("${sharePath}/icons/${theme}/scalable/${iconname}.svg"*)
        if [[ ${#scalableIcon[@]} = 0 ]]; then
            scalableIcon=('-')
        fi

        for iconSize in "${iconSizes[@]}"; do
            for scale in "${!scales[@]}"; do
                local iconResult=$(findIcon $iconSize $scale)
                local type=${iconResult%% *}
                local icon=${iconResult#* }
                local scaleSuffix=${scales[$scale]}
                local result=${resultdir}/${iconSize}x${iconSize}${scales[$scale]}${scaleSuffix:+x}.png
                case $type in
                    fixed)
                        local density=$((72 * scale))x$((72 * scale))
                        magick convert -density "$density" -units PixelsPerInch "$icon" "$result"
                        ;;
                    threshold)
                        # Synthesize an icon of the exact size if a scalable icon is available
                        # instead of scaling one and ending up with a fuzzy icon.
                        if ! synthesizeIcon "${scalableIcon[0]}" "$result" "$iconSize" "$scale"; then
                            resizeIcon "$icon" "$result" "$iconSize" "$scale"
                        fi
                        ;;
                    scalable)
                        synthesizeIcon "${scalableIcon[0]}" "$result" "$iconSize" "$scale" || true
                        ;;
                    *)
                        ;;
                esac
            done
        done
        echo "$resultdir"
    }

    iconsdir=$(getIcons "$sharePath" "apps/${iconName}" "$theme")
    if [[ ! -z "$(ls -1 "$iconsdir/"*)" ]]; then
        icnsutil compose "$out/${iconName}.icns" "$iconsdir/"*
    else
        echo "Warning: no icons were found. Creating an empty icon for ${iconName}.icns."
        touch "$out/${iconName}.icns"
    fi
}

# For a given .desktop file, generate a darwin '.app' bundle for it.
convertDesktopFile() {
    local -r file=$1
    local -r sharePath=$(dirname "$(dirname "$file")")
    local -r name=$(getDesktopParam "${file}" "^Name")
    local -r exec=$(getDesktopParam "${file}" "Exec")
    local -r iconName=$(getDesktopParam "${file}" "^Icon")
    local -r squircle=$(getDesktopParam "${file}" "X-macOS-SquircleIcon")

    mkdir -p "$out/Applications/${name}.app/Contents/MacOS"
    mkdir -p "$out/Applications/${name}.app/Contents/Resources"

    convertIconTheme "$out/Applications/${name}.app/Contents/Resources" "$sharePath" "$iconName"

    write-darwin-bundle "$out" "$name" "$exec" "$iconName" "$squircle"
}

convertDesktopFiles() {
    local dir="$1/share/applications/"

    if [ -d "${dir}" ]; then
        for desktopFile in $(find "$dir" -iname "*.desktop"); do
            convertDesktopFile "$desktopFile";
        done
    fi
}
