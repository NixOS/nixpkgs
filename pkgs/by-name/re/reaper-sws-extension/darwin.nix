{
  stdenvNoCC,
  fetchurl,
  pname,
  version,
  meta,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    meta
    ;
  srcs =

    let
      plugin = fetchurl {
        url = "https://github.com/reaper-oss/sws/releases/download/v${finalAttrs.version}/reaper_sws-arm64.dylib";
        hash = "sha256-jmuob0qslYhxiE2ShfTwY4RJAKBLJSUb+VBEM0sQPbo=";
      };
    in
    [
      plugin
      (fetchurl {
        url = "https://github.com/reaper-oss/sws/releases/download/v${finalAttrs.version}/sws_python64.py";
        hash = "sha256-GDlvfARg1g5oTH2itEug6Auxr9iFlPDdGueInGmHqSI=";
      })
      (fetchurl {
        url = "https://github.com/reaper-oss/sws/releases/download/v${finalAttrs.version}/sws_python32.py";
        hash = "sha256-np2r568csSdIS7VZHDASroZlXhpfxXwNn0gROTinWU4=";
      })
    ];

  unpackCmd = ''
    cp $curSrc $(stripHash $curSrc)
  '';

  installPhase = ''
    runHook preInstall
    install -D -t $out/Scripts *.py
    install -D -t $out/UserPlugins *.dylib
    runHook postInstall
  '';
})
