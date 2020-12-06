{ stdenvNoCC
, lib
, timeshift-unwrapped
, wrapGAppsHook
, gdk-pixbuf
, librsvg
, shared-mime-info
}:
propagatedBuildInputs:

stdenvNoCC.mkDerivation {
  inherit (timeshift-unwrapped) pname version;

  dontUnpack = true;

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  inherit propagatedBuildInputs;

  ## Wrappable `lndir "${timeshift-wrapped}" "$out"`
  ## with "$out/nix-support" removed

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    (
      FROMDIR="${timeshift-unwrapped}"
      TODIR="$out"

      LENGTH_FROMDIR="''${#FROMDIR}"

      while IFS= read -d $'\0' -r ORIGINAL_DIR; do
        mkdir "$TODIR''${ORIGINAL_DIR:$LENGTH_FROMDIR}"
      done < <(find "$FROMDIR" -mindepth 1 -type d -print0)

      while IFS= read -d $'\0' -r ORIGINAL_FILE; do
        ln -s "$ORIGINAL_FILE" "$TODIR''${ORIGINAL_FILE:$LENGTH_FROMDIR}"
      done < <(find "$FROMDIR" -mindepth 1 -type f -print0)

      while IFS= read -d $'\0' -r ORIGINAL_LINK; do
        NEW_SYMLINK="$TODIR''${ORIGINAL_LINK:$LENGTH_FROMDIR}"
        ORIGINAL_TARGET="$($READLINK_COMMAND "$ORIGINAL_LINK")"
        LENGTH_ORIGINAL_TARGET="''${#ORIGINAL_TARGET}"
        NEW_TARGET="$ORIGINAL_TARGET"
        if [[ "$LENGTH_ORIGINAL_TARGET" -ge "$LENGTH_FROMDIR" ]] \
        && [[ "''${ORIGINAL_TARGET:0:$LENGTH_FROMDIR}" == "$FROMDIR" ]]; then
          NEW_TARGET="$TODIR''${ORIGINAL_TARGET:$LENGTH_FROMDIR}"
        fi
        $SYMLINK_COMMAND "$NEW_TARGET" "$NEW_SYMLINK"
      done < <(find "$FROMDIR" -mindepth 1 -type l -print0)
    )
    rm -r "$out/nix-support"
    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
    declare -a makeWrapperArgs=(
      --prefix PATH : "${lib.makeBinPath propagatedBuildInputs}"
    )
    declare -a makeWrapperArgsWithGApps=("''${makeWrapperArgs[@]}" "''${gappsWrapperArgs[@]}")
    wrapProgram "$out/bin/timeshift" "''${makeWrapperArgs[@]}"
    wrapProgram "$out/bin/timeshift-gtk" "''${makeWrapperArgsWithGApps[@]}"
  '';

  inherit (timeshift-unwrapped) meta;
}
