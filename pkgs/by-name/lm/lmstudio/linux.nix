{ lib
, appimageTools
, fetchurl
, version
, pname
, meta
}:
let
  src = fetchurl {
    url = "https://releases.lmstudio.ai/linux/${version}/beta/LM_Studio-${version}.AppImage";
    hash = "sha256-hcV8wDhulFAxHDBDKicpEGovwcsn9RaIi/idUz+YzD8=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit meta pname version src;

  extraPkgs = pkgs: [ pkgs.ocl-icd ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
    install -m 444 -D ${appimageContents}/lm-studio.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/lm-studio.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=lmstudio'
  '';
}

