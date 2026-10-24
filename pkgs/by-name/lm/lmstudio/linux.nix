{
  appimageTools,
  fetchurl,
  version,
  url,
  hash,
  pname,
  meta,
  stdenv,
  passthru,
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

  extraPkgs = pkgs: [ pkgs.ocl-icd ];

  extraInstallCommands = ''
    # upstream ships pre-rendered icons for every hicolor size
    mkdir -p $out/share/icons
    cp -r ${appimageContents}/usr/share/icons/hicolor $out/share/icons/

    install -m 444 -D ${appimageContents}/ai.elementlabs.lmstudio.desktop \
      -t $out/share/applications

    # Rename the main executable from lmstudio to lm-studio
    mv $out/bin/lmstudio $out/bin/lm-studio

    substituteInPlace $out/share/applications/ai.elementlabs.lmstudio.desktop \
      --replace-fail 'Exec=AppRun %U' 'Exec=lm-studio %U'

    # lms cli tool
    install -m 755 ${appimageContents}/resources/app/.webpack/lms $out/bin/

    patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $out/bin/lms
  '';
}
