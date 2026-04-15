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

    # lms cli tool
    install -m 755 ${appimageContents}/resources/app/.webpack/lms $out/bin/

    patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
    --set-rpath "${lib.getLib stdenv.cc.cc}/lib:${lib.getLib stdenv.cc.cc}/lib64:$out/lib:${
      lib.makeLibraryPath [ (lib.getLib stdenv.cc.cc) ]
    }" $out/bin/lms
  '';
}
