{
  appimageTools,
  fetchurl,
  version,
  url,
  hash,
  pname,
  meta,
  stdenv,
  lib,
  passthru,
  graphicsmagick,
  lms,
  jq,
}:
let
  src = fetchurl { inherit url hash; };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit
    meta
    pname
    version
    src
    passthru
    ;

  nativeBuildInputs = [ graphicsmagick ];

  extraPkgs = pkgs: [ pkgs.ocl-icd ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications

    # setup icons (see https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=lmstudio#n55 for how Arch solved this; approach adapted to here)
    src_icon="${appimageContents}/usr/share/icons/hicolor/0x0/apps/lm-studio.png"
    sizes=("16x16" "32x32" "48x48" "64x64" "128x128" "256x256")
    for size in "''${sizes[@]}"; do
      install -dm755 "$out/share/icons/hicolor/$size/apps"
      gm convert "$src_icon" -resize "$size" "$out/share/icons/hicolor/$size/apps/lm-studio.png"
    done

    install -m 444 -D ${appimageContents}/lm-studio.desktop -t $out/share/applications

    # Rename the main executable from lmstudio to lm-studio
    mv $out/bin/lmstudio $out/bin/lm-studio

    substituteInPlace $out/share/applications/lm-studio.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=lm-studio'

    # lms cli tool — built from source via lms.nix
    install -m 755 ${lms}/bin/lms $out/bin/.lms-unwrapped

    patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
    --set-rpath "${lib.getLib stdenv.cc.cc}/lib:${lib.getLib stdenv.cc.cc}/lib64:$out/lib:${
      lib.makeLibraryPath [ (lib.getLib stdenv.cc.cc) ]
    }" $out/bin/.lms-unwrapped

    # Wrap lms so it can find the LM Studio binary from the Nix store.
    # The lms CLI discovers LM Studio via ~/.lmstudio/.internal/app-install-location.json
    # (or ~/.cache/lm-studio/.internal/app-install-location.json).  When LM Studio is
    # installed via Nix this file does not exist, so lms cannot find or start the daemon.
    # The wrapper ensures the file points to the Nix-packaged lm-studio binary.
    cat > $out/bin/lms <<'WRAPPER'
#!/bin/sh
# Determine LM Studio home the same way the JS code does
if [ -f "$HOME/.lmstudio-home-pointer" ]; then
  LMSTUDIO_HOME=$(cat "$HOME/.lmstudio-home-pointer")
elif [ -d "$HOME/.cache/lm-studio" ]; then
  LMSTUDIO_HOME="$HOME/.cache/lm-studio"
else
  LMSTUDIO_HOME="$HOME/.lmstudio"
fi

install_file="$LMSTUDIO_HOME/.internal/app-install-location.json"

# Only write if the file is missing or points to a non-existent path
needs_update=0
if [ ! -f "$install_file" ]; then
  needs_update=1
elif ! @jq@ -e '.path' "$install_file" >/dev/null 2>&1; then
  needs_update=1
elif [ ! -e "$(@jq@ -r '.path' "$install_file")" ]; then
  needs_update=1
fi

if [ "$needs_update" = 1 ]; then
  mkdir -p "$(dirname "$install_file")"
  printf '{"path":"%s","argv":[],"cwd":"%s"}\n' "@lm_studio@" "@bindir@" > "$install_file"
fi

exec @lms_unwrapped@ "$@"
WRAPPER
    substituteInPlace $out/bin/lms \
      --replace-fail '@jq@' '${jq}/bin/jq' \
      --replace-fail '@lm_studio@' "$out/bin/lm-studio" \
      --replace-fail '@bindir@' "$out/bin" \
      --replace-fail '@lms_unwrapped@' "$out/bin/.lms-unwrapped"
    chmod 755 $out/bin/lms
  '';
}
