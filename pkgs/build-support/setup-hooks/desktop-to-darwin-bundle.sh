# shellcheck shell=bash
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

    # Sizes based on archived Apple documentation:
    # https://developer.apple.com/design/human-interface-guidelines/macos/icons-and-images/app-icon#app-icon-sizes
    local -ra iconSizes=(16 32 128 256 512)
    local -ra scales=([1]="" [2]="@2")

    # Based loosely on the algorithm at:
    # https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html#icon_lookup
    # Assumes threshold = 2 for ease of implementation.
    function findIcon() {
        local -r iconSize=$1
        local -r scale=$2

        local scaleSuffix=${scales[$scale]}
        local exactSize=${iconSize}x${iconSize}${scaleSuffix}

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
                elif [[ -a $icon ]]; then
                  echo "fallback $icon"
                fi
                return 0
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

        # Tri-state variable, NONE means no icons have been found, an empty
        # icns file will be generated, not sure that's necessary because macOS
        # will default to a generic icon if no icon can be found.
        #
        # OTHER means an appropriate icon was found.
        #
        # Any other value is a path to an icon file that isn't scalable or
        # within the threshold. This is used as a fallback in case no better
        # icon can be found and will be scaled as much as
        # necessary to result in appropriate icon sizes.
        local foundIcon=NONE
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
                        foundIcon=OTHER
                        ;;
                    threshold)
                        # Synthesize an icon of the exact size if a scalable icon is available
                        # instead of scaling one and ending up with a fuzzy icon.
                        if ! synthesizeIcon "${scalableIcon[0]}" "$result" "$iconSize" "$scale"; then
                            resizeIcon "$icon" "$result" "$iconSize" "$scale"
                        fi
                        foundIcon=OTHER
                        ;;
                    scalable)
                        synthesizeIcon "${scalableIcon[0]}" "$result" "$iconSize" "$scale" || true
                        foundIcon=OTHER
                        ;;
                    fallback)
                        # Use the largest size available to scale to
                        # appropriate sizes.
                        if [[ $foundIcon != OTHER ]]; then
                          foundIcon=$icon
                        fi
                        ;;
                    *)
                        ;;
                esac
            done
        done
        if [[ $foundIcon != NONE && $foundIcon != OTHER ]]; then
            # Ideally we'd only resize to whatever the closest sizes are,
            # starting from whatever icon sizes are available.
            for iconSize in 16 32 128 256 512; do
              local result=${resultdir}/${iconSize}x${iconSize}.png
              resizeIcon "$foundIcon" "$result" "$iconSize" 1
            done
        fi
        echo "$resultdir"
    }

    iconsdir=$(getIcons "$sharePath" "apps/${iconName}" "$theme")
    if [[ -n "$(ls -A1 "$iconsdir")" ]]; then
        icnsutil compose --toc "$out/${iconName}.icns" "$iconsdir/"*
    else
        echo "Warning: no icons were found. Creating an empty icon for ${iconName}.icns."
        touch "$out/${iconName}.icns"
    fi
}

processExecFieldCodes() {
  local -r file=$1
  local -r execRaw=$(getDesktopParam "${file}" "Exec")
  local -r execNoK="${execRaw/\%k/${file}}"
  local -r execNoKC="${execNoK/\%c/$(getDesktopParam "${file}" "Name")}"
  local -r icon=$(getDesktopParam "${file}" "Icon")
  local -r execNoKCI="${execNoKC/\%i/${icon:+--icon }${icon}}"
  local -r execNoKCIfu="${execNoKCI/\%[fu]/\$1}"
  local -r exec="${execNoKCIfu/\%[FU]/\$@}"
  if [[ "$exec" != "$execRaw" ]]; then
    echo 1>&2 "desktopToDarwinBundle: Application bundles do not understand desktop entry field codes. Changed '$execRaw' to '$exec'."
  fi
  echo "$exec"
}

# For a given .desktop file, generate a darwin '.app' bundle for it.
convertDesktopFile() {
    local -r file=$1
    local -r sharePath=$(dirname "$(dirname "$file")")
    local -r name=$(getDesktopParam "${file}" "^Name")
    local -r macOSExec=$(getDesktopParam "${file}" "X-macOS-Exec")
    if [[ "$macOSExec" ]]; then
      local -r exec="$macOSExec"
    else
      local -r exec=$(processExecFieldCodes "${file}")
    fi
    local -r iconName=$(getDesktopParam "${file}" "^Icon")
    local -r squircle=$(getDesktopParam "${file}" "X-macOS-SquircleIcon")

    mkdir -p "${!outputBin}/Applications/${name}.app/Contents/MacOS"
    mkdir -p "${!outputBin}/Applications/${name}.app/Contents/Resources"

    convertIconTheme "${!outputBin}/Applications/${name}.app/Contents/Resources" "$sharePath" "$iconName"

    write-darwin-bundle "${!outputBin}" "$name" "$exec" "$iconName" "$squircle"
}

convertDesktopFiles() {
    local dir="$1/share/applications/"

    if [ -d "${dir}" ]; then
        for desktopFile in $(find "$dir" -iname "*.desktop"); do
            convertDesktopFile "$desktopFile";
        done
    fi
}
