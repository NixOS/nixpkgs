{
  appimageTools,
  fetchurl,
  pname,
  commonMeta,
  version,
}:

appimageTools.wrapType2 rec {
  inherit
    pname
    version
    ;
  src = fetchurl {
    url = "https://github.com/GoldenCheetah/GoldenCheetah/releases/download/v${version}/GoldenCheetah_v${builtins.substring 0 7 version}_x64.AppImage";
    hash = "sha256-S1YDg7opoYflL/3h+lP1SNwXpJHaN3+iE3waSjWtN6o=";
  };

  extraPkgs = pkgs: [
    pkgs.R
    pkgs.zlib
    pkgs.libusb-compat-0_1
  ];

  appimageContents = appimageTools.extract { inherit pname src version; };

  extraInstallCommands = ''
    mv $out/bin/${pname} $out/bin/GoldenCheetah
    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps
    cp ${appimageContents}/GoldenCheetah.desktop $out/share/applications/
    substituteInPlace $out/share/applications/GoldenCheetah.desktop --replace-fail \
      "Exec=GoldenCheetah" "Exec=QT_PLUGIN_PATH= GoldenCheetah"
    cp ${appimageContents}/gc.png $out/share/pixmaps/
  '';
  meta = {
    inherit (commonMeta)
      description
      platforms
      maintainers
      license
      sourceProvenance
      ;
  };
}
