{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "libmaddy-markdown";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "progsource";
    repo = "maddy";
    tag = finalAttrs.version;
    hash = "sha256-sVUXACT94PSPcohnOyIp7KK8baCBuf6ZNMIyk6Cfdjg=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include/maddy
    install -Dm444 include/maddy/* -t $out/include/maddy

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++ Markdown to HTML header-only parser library";
    homepage = "https://github.com/progsource/maddy";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.normalcea ];
    platforms = lib.platforms.unix;
  };
})
