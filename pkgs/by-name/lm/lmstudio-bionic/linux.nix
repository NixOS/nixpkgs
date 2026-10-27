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
}:
let
  src = fetchurl { inherit url hash; };

  appimageContents = appimageTools.extract { inherit pname version src; };
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
    src_icon="${appimageContents}/bionic.png"
    sizes=("16x16" "32x32" "48x48" "64x64" "128x128" "256x256")
    for size in "''${sizes[@]}"; do
      install -dm755 "$out/share/icons/hicolor/$size/apps"
      gm convert "$src_icon" -resize "$size" "$out/share/icons/hicolor/$size/apps/bionic.png"
    done

    install -m 444 -D ${appimageContents}/ai.elementlabs.bionic.desktop $out/share/applications/bionic.desktop

    # Rename the main executable from lmstudio-bionic to bionic
    mv $out/bin/lmstudio-bionic $out/bin/bionic

    substituteInPlace $out/share/applications/bionic.desktop \
      --replace-fail 'Exec=AppRun %U' 'Exec=bionic'

    # lms cli tool
    install -m 755 ${appimageContents}/resources/app/.webpack-bionic/lms $out/bin/

    patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $out/bin/lms
  '';
}
