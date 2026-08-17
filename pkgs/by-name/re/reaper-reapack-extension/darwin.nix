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
  src = fetchurl {
    url =
      let
        arch = if stdenvNoCC.hostPlatform.system == "x86_64-darwin" then "x86_64" else "arm64";
      in
      "https://github.com/cfillion/reapack/releases/download/v${finalAttrs.version}/reaper_reapack-${arch}.dylib";
    hash =
      {
        x86_64-darwin = "sha256-slLzjIWpEzOn4GAcRwb6WdJSVExuQK0cVgHgd7qM4oE=";
        aarch64-darwin = "sha256-eFKEUuTUWE4Wp/vWVrvTbK78U6TicvRXSWggVAH2Og4=";
      }
      .${stdenvNoCC.hostPlatform.system};
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -D * -t $out/UserPlugins
    runHook postInstall
  '';
})
