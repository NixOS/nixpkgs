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
        url =
          let
            arch = if stdenvNoCC.hostPlatform.system == "x86_64-darwin" then "x86_64" else "arm64";
          in
          "https://github.com/reaper-oss/sws/releases/download/v${finalAttrs.version}/reaper_sws-${arch}.dylib";
        hash =
          {
            x86_64-darwin = "sha256-c0enRIXFN+dMDdxTQ3hFv0almTF0dfrSHILNigJp2Js=";
            aarch64-darwin = "sha256-jmuob0qslYhxiE2ShfTwY4RJAKBLJSUb+VBEM0sQPbo=";
          }
          .${stdenvNoCC.hostPlatform.system};
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

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -D *.py -t $out/Scripts
    install -D *.dylib -t $out/UserPlugins
    runHook postInstall
  '';
})
