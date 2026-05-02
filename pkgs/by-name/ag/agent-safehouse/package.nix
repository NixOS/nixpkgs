{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "safehouse";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "eugene1g";
    repo = "agent-safehouse";
    rev = "v" + version;
    hash = "sha256-GuZQF43G23+EZsQIx3hlA59HYCDG3chjs3kygU5dS9o=";
  };

  postPatch = "patchShebangs scripts bin";

  buildPhase = ''
    runHook preBuild
    scripts/generate-dist.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/safehouse.sh $out/bin/safehouse

    runHook postInstall
  '';

  meta = {
    description = "Sandbox your local AI agents so they can read/write only what they need";
    homepage = "https://github.com/eugene1g/agent-safehouse";
    mainProgram = "safehouse";
    license = lib.licenses.asl20;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ myzel394 ];
  };
}
