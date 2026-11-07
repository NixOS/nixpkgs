# shellcheck shell=bash

# Looks for a path with the pattern
# *${NAME}*.*${EXTENSION}
#
# So that both files containing a fragment, and directories are matched.
#
# Args:
# 1 = The directory to search
# 2 = The name to glob for
# 3 = The extension to glob for
#
# Returns:
# str -> The path found
findIcon() {
  local -r searchDir="$1"
  local -r name="$2"
  local -r extension="$3"

  local -a resultArray=()

  local -ra findArgs=(
   # Search for files in the the user-provided dir, or the cwd if not provided
   "${searchDir}" "-type" "f"
   # Search for name and extension
   "-ipath" "*${name}*.*${extension}"
   # print them with null seperating
   "-print0"
  )

  # If not, try searching for a file to use
  # We are looking for an SVG file specifically.
  readarray -td '' resultArray < <(find "${findArgs[@]}")

  if [[ ${#resultArray[@]} -eq 1 ]]; then
    # Found exactly one item
    echo "${resultArray[0]}"
  elif [[ ${#resultArray[@]} -eq 0 ]]; then
    echo ""
  else
    echo "${resultArray[*]}"
    exit 1
  fi
}

# Checks whether an icon is a png or SVG
# Techinically we could allow XPM, but freedesktop
# recommends not using those.
#
# $1 = path to icon
getMime() {
  local -r iconPath="$1"

  file -b --mime-type "$iconPath"
}

# The default for almost all icons that will be installed.
# This should be preferred.
#
# Installs to
# "$prefix/share/icons/hicolor/*/app/$name.*"
#
# Args:
# $1 = Prefix to install it to (usually $out or $bin)
# $2 = Path to install it from
# $3 = Name to install it with (excluding the extension!)
# $4 = Type of icon to install [ "scalable", "NxN" ]
#
# Return:
#  * Ignore stdout, it is for logging
#  * Calls `exit 1` if invalid type is provided
#
# Examples:
#
#   installHicolorIcon "$out" "assets/icon.png" "cool_project" "64x64"
#
#   installHicolorIcon "$bin" "assets/icon.svg" "cooler_project" "scalable"
installHicolorIcon() {
  local -r prefix="$1"
  local -r location="$2"
  local -r name="$3"
  local -r type="$4"

  local -r path="share/icons/hicolor"

  case "${type,,}" in
    "scalable")
      >&2 echo "installHicolorIcon: installing SVG '$location' to '$prefix/$path/scalable/apps/$name.svg'"
      install -Dm444 "$location" "$prefix/$path/scalable/apps/$name.svg"
      ;;
    *x*)
      >&2 echo "installHicolorIcon: installing png '$location' to '$prefix/$path/$type/apps/$name.png'"
      install -Dm444 "$location" "$prefix/$path/$type/apps/$name.png"
      ;;
    *)
      >&2 echo "installHicolorIcon: invalid icon type '$type'"
      exit 1
      ;;
  esac
}

# For other icons that are too large or weird
# in other ways.
#
# https://github.com/NixOS/nixpkgs/issues/428824#issuecomment-4255463416
#
# Installs to
# "$prefix/share/icons/$name"
#
# Args:
# $1 = Prefix to install it to (usually $out or $bin)
# $2 = Path to install it from
# $3 = Name to install it with (including the extension!)
#
# Return:
#  * Ignore stdout, it is for logging
#  * Returns `1` if unknown type is provided
#
# Examples:
#
#   installOtherIcon "$out" "assets/icon.png" "project.png"
installOtherIcon() {
  local -r prefix="$1"
  local -r location="$2"
  local -r name="$3"

  local -r path="$prefix/share/icons/$name"

  >&2 echo "installOtherIcon: '$location' to '$path'"
  install -Dm444 "$location" "$path"
}

installIconsHook() {
  echo "installIconsHook: Running..."

  local -ra RASTER_SIZES=(
    "16x16"
    "32x32"
    "48x48"
    "64x64"
    "72x72"
    "96x96"
    "128x128"
    "256x256"
    "512x512"
  )

  # Directory to search. Default to CWD
  local -r searchDir="${installIconsSearchDir:-.}"

  # Must eagerly fail for this as we'll just spit out nonsense otherwise
  if [[ ! $__structuredAttrs ]]; then
    >&2 echo "installIconsHook: structuredAttrs is required"
    exit 1
  fi

  # Make sure the name exists and is an assoc array
  declare -gA iconsToInstall

  # Make an assoc array of each icon type to lookup
  local -A foundIcons=()

  # Don't eagerly fail so we can output errors for all icons
  # if there is more than one error to occur.
  local failedFind=false

  # The name to install the icons under
  local -r iconName="${installIconName:-"$NIX_MAIN_PROGRAM"}"
  if [[ -z "$iconName" ]]; then
    >&2 echo "installIconsHook: ERROR: meta.mainProgram is unset, please set it so the icon name is valid"
    >&2 echo "installIconsHook: If meta.mainProgram cannot be set, please use 'installIconName' instead."
    failedFind=true
  fi

  # Get the user input, and if not try to find the file
  for size in "${RASTER_SIZES[@]}"; do
    if [[ -v iconsToInstall["$size"] ]]; then
      # If key exists, use it.
      >&2 echo "installIconsHook: user supplied $size"
      foundIcons["$size"]="${iconsToInstall["$size"]}"
    else

      # Try to find the size of icon
      local findResult
      if
        ! findResult="$(findIcon "$searchDir" "$size" "png")"
      then
        failedFind=true
        >&2 echo "installIconsHook: ERROR: Found multiple icons for size '$size'"
        >&2 echo "installIconsHook: disambiguate with attribute set \`iconsToInstall\`"
        >&2 echo "$findResult"
      else
        if [[ -n $findResult ]]; then
          # If we found it, use it.
          foundIcons["$size"]="$findResult"
          >&2 echo "installIconsHook: Found icon of size '$size'"
        else
          # Found nothing
          >&2 echo "installIconsHook: Unable to find icon size '$size'"
        fi
      fi
    fi
  done

  # Look for SVG and ICO files
  for type in "svg" "ico"; do
    if [[ -v iconsToInstall["$type"] ]]; then
      # If supplied, we shall use it
      >&2 echo "installIconsHook: user supplied $type"
      foundIcons["$type"]="${iconsToInstall["$type"]}"
    else
      # Try to find the icon
      local found
      if
        ! found="$(findIcon "$searchDir" "" "$type")"
      then
        failedFind=true
        >&2 echo "installIconsHook: ERROR: Found multiple icons for type '$type'"
        >&2 echo "installIconsHook: disambiguate with attribute set \`iconsToInstall\`"
        >&2 echo "$found"
      else
        if [[ -n $found ]]; then
          # If we found it, use it.
          foundIcons["$type"]="$found"
          >&2 echo "installIconsHook: Found icon type '$type'"
        else
          # Found nothing
          >&2 echo "installIconsHook: Unable to find icon type '$type'"
        fi
      fi
    fi
  done

  if $failedFind; then
    >&2 echo "installIconsHook: Errors found, exiting"
    exit 1
  fi

  # Do ICO install first so that it is the lowest priority of the icons found
  if [[ -v foundIcons["ico"]  ]]; then
    icoFileToHiColorTheme "${foundIcons["ico"]}" "$iconName" "$prefix"
  fi

  # Just install whatever we found or created
  for key in "${!foundIcons[@]}"; do
    # Must declare seperately to get return code
    local mimeType
    if
      ! mimeType="$(getMime "${foundIcons["$key"]}")"
    then
      >&2 echo "Unable to get mime of '${foundIcons["$key"]}'"
      >&2 echo "$mimeType"
      exit 1
    fi

    case "$key" in
      "ico")
        # Do nothing, we already installed it above
        ;;
      "svg")
        local correctMime="image/svg+xml"

        if [[ "$mimeType" == "$correctMime" ]]; then
          installHicolorIcon "$prefix" "${foundIcons["$key"]}" "$iconName" "scalable"
        else
          >&2 echo "installIconsHook: ERROR: '${foundIcons["$key"]}' is not a '$correctMime'" 2>&1
          exit 1
        fi
        ;;
      *)
        local correctMime="image/png"

        if [[ "$mimeType" == "$correctMime" ]]; then
          installHicolorIcon "$prefix" "${foundIcons["$key"]}" "$iconName" "$key"
        else
          >&2 echo "installIconsHook: ERROR: '${foundIcons["$key"]}' is not a '$correctMime'" 2>&1
          exit 1
        fi
        ;;
    esac
  done

  # Check if there are "other" icons. These will be too large
  # or some other quirk that means they cannot be installed in
  # hicolor paths.
  declare -gA extraIconsToInstall
  for extension in "${!extraIconsToInstall[@]}"; do
    local correctMime=""

    case "$extension" in
      svg)
        correctMime="image/svg+xml"
        ;;
      png)
        correctMime="image/png"
        ;;
      *)
      >&2 echo "installIconsHooks: ERROR: '$extension' is not a valid format, only png and svg are allowed."
      exit 1
      ;;
    esac

    local icon="${extraIconsToInstall["$extension"]}"

    # Must declare seperately to get return code
    local mimeType
    if
      ! mimeType="$(getMime "$icon")"
    then
      >&2 echo "Unable to get mime of '$icon'"
      >&2 echo "$mimeType"
      exit 1
    fi

    if [[ "$mimeType" != "$correctMime" ]]; then
      echo "installIconsHook: ERROR: '$icon' is not a $extension file"
      exit 1
    fi

    installOtherIcon "$prefix" "$icon" "$iconName.$extension"
  done

  echo "installIconsHook: Finished."
}

if [ -z "${dontInstallIcons-}" ]; then
  postInstallHooks+=(installIconsHook)
fi

