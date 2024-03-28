{
  lib,
  buildDubPackage,
  fetchFromGitHub,
  dtools,
}:

buildDubPackage rec {
  pname = "serve-d";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "Pure-D";
    repo = "serve-d";
    rev = "v${version}";
    hash = "sha256-h4zsW8phGcI4z0uMCIovM9cJ6hKdk8rLb/Jp4X4dkpk=";
  };

  nativeBuildInputs = [ dtools ];

  dubDeps = ./deps.nix;

  doCheck = false;

  installPhase = ''
    runHook preInstall
    install -Dm755 serve-d -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "";
    homepage = "";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
