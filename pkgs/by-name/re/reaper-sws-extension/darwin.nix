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
            x86_64-darwin = "sha256-B185QWS9FaC/0XDhxUBbgr9zu2Ot8OIsfaPQ3sUHh4s=";
            aarch64-darwin = "sha256-8gbyPlnIXdWtSD+Aj70xzacJhO34edTTG2IOryB67os=";
          }
          .${stdenvNoCC.hostPlatform.system};
      };
    in
    [
      plugin
      (fetchurl {
        url = "https://github.com/reaper-oss/sws/releases/download/v${finalAttrs.version}/sws_python64.py";
        hash = "sha256-Yujj60+jOEfdSZ74cRU1Wxoh7RL2fo/IhJIpa+BDYV0=";
      })
      (fetchurl {
        url = "https://github.com/reaper-oss/sws/releases/download/v${finalAttrs.version}/sws_python32.py";
        hash = "sha256-QktzdIDpTvNs9IrH7TOI6LTIBkfuQ3cqw06iqLxSSTI=";
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
