{
  lib,
  fetchFromGitLab,
  stdenv,
  fennel,
}:

stdenv.mkDerivation rec {
  pname = "deps.fnl";
  version = "0.2.6";

  src = fetchFromGitLab {
    owner = "andreyorst";
    repo = "deps.fnl";
    tag = version;
    hash = "sha256-FrFeRbfK4sHd3pjiVDMrE8IpDKptZuwkTLMQ9hppVRY=";
  };

  buildInputs = [ fennel ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 deps -t $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Dependency and PATH manager for Fennel";
    homepage = "https://gitlab.com/andreyorst/deps.fnl";
    license = lib.licenses.mit;
    mainProgram = "deps";
    maintainers = with lib.maintainers; [ emily-lavender ];
    platforms = lib.platforms.all;
  };
}
