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
    echo "installIconsHook: ERROR found more than one icon"
    echo "installIconsHook: disambiguate with attribute set \`iconsToInstall\`"
    echo "${resultArray[@]/%/$'\n'}"
    exit 1
  fi
}

# Args:
# 1 = Prefix to install it to (usually $out or $bin)
# 2 = Path to install it from
# 3 = Name to install it with
# 4 = Type of icon to install [ "scalable", "NxN" ]
#
# Return:
# None
installIcon() {
  local -r prefix="$1"
  local -r location="$2"
  local -r name="$3"
  local -r type="$4"

  local -r path="share/icons/hicolor"

  case "${type,,}" in
    "scalable")
      echo "installIconsHook: installing SVG '$location' to '$prefix/$path/scalable/apps/$name.svg'"
      install -Dm444 "$location" "$prefix/$path/scalable/apps/$name.svg"
      ;;
    *x*)
      echo "installIconsHook: installing png '$location' to '$prefix/$path/$type/apps/$name.png'"
      install -Dm444 "$location" "$prefix/$path/$type/apps/$name.png"
      ;;
    *)
      echo "installIconsHook: invalid icon type '$type'"
      exit 1
      ;;
  esac
}

installIconsHook() {
  echo "installIconsHook: Running..."

  local -ra RASTER_SIZES=(
    "8x8"
    "16x16"
    "32x32"
    "46x46"
    "64x64"
    "96x96"
    "128x128"
    "256x256"
    "512x512"
  )

  # Directory to search. Default to CWD
  local -r searchDir="${iconInstallSearch:-.}"

  # The name to install the icons under
  local -r iconName="${iconInstallName:-"$NIX_MAIN_PROGRAM"}"

  if [[ ! $__structuredAttrs ]]; then
    echo "installIconsHook: structuredAttrs is required"
    exit 1
  fi

  # Must conditionally declare it, or else bash will
  # think it's a normal array
  if [[ ! -v iconsToInstall ]]; then
    local -A iconsToInstall
  fi

  # Make an assoc array of each icon type to lookup
  local -A foundIcons=()

  # Get the user input, and if not try to find the file
  for size in "${RASTER_SIZES[@]}"; do
    if [[ -v iconsToInstall["$size"] ]]; then
      # If key exists, use it.
      echo "installIconsHook: user supplied $size"
      foundIcons["$size"]=iconsToInstall["$size"]
    else

      # Try to find the size of icon
      local findResult="$(findIcon "$searchDir" "$size" "png")"

      if [[ -n $findResult ]]; then
        # If we found it, use it.
        foundIcons["$size"]="$findResult"
        echo "installIconsHook: Found icon of size '$size'"
      else
        # Found nothing
        echo "installIconsHook: Unable to find icon size '$size'"
      fi
    fi
  done

  # Look for SVG and ICO files
  for type in "svg" "ico"; do
    if [[ -v iconsToInstall["$type"] ]]; then
      # If supplied, we shall use it
      echo "installIconsHook: user supplied $type"
      foundIcons["$type"]=iconsToInstall["$type"]
    else
      # Try to find the icon
      found="$(findIcon "$searchDir" "" "$type")"

      if [[ -n $found ]]; then
        # If we found it, use it.
        foundIcons["$type"]="$found"
        echo "installIconsHook: Found icon type '$type'"
      else
        # Found nothing
        echo "installIconsHook: Unable to find icon type '$type'"
      fi
    fi
  done

  # Do ICO install first so that it is the lowest priority of the icons found
  if [[ -v foundIcons["ico"]  ]]; then
    icoFileToHiColorTheme "${foundIcons["ico"]}" "$iconName" "$prefix"
  fi

  # Just install whatever we found or created
  for key in "${!foundIcons[@]}"; do
    case "$key" in
      "ico")
        # Do nothing, we already installed it above
        ;;
      *)
        # Check it is really what it says it is
        # 1. ask file what it is
        # 2. Discard everything before the null (the file path)
        local -l mimeType="$(file --mime-type -0F '' "${foundIcons["$key"]}" | sed -z '1d')"

        if [[ "$key" == "svg" ]]; then
          local -l correctMime="image/svg"
        else
          local -l correctMime="image/png"
        fi

        if [[ "$mimeType" == *"$correctMime"* ]]; then
          installIcon "$prefix" "${foundIcons["$key"]}" "$iconName" "$key"
        else
          echo "installIconsHook: ERROR: '${foundIcons["$key"]}' is not a '$correctMime'"
          exit 1
        fi
        ;;
    esac
  done

  echo "installIconsHook: Finished."
}

postInstallHooks+=(installIconsHook)
