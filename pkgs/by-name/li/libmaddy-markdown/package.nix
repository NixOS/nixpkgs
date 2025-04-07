{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "libmaddy-markdown";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "progsource";
    repo = "maddy";
    tag = finalAttrs.version;
    hash = "sha256-cc0RggNYn0wZpeCn5QU9C+sqv7CTJkiQVB3LSQ/3YQw=";
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
