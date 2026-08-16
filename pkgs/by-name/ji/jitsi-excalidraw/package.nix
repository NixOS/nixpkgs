{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  python3,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "jitsi-excalidraw-backend";
  version = "2026.3.0";

  src = fetchFromGitHub {
    owner = "jitsi";
    repo = "excalidraw-backend";
    rev = version;
    hash = "sha256-ji5qSnT/FNHEDm6v8Fw9SW3N9RzEr2AbeQq+PNehZGo=";
  };

  npmDepsHash = "sha256-lOytyKRu7kh3UcUkbEEErntqb7aUzULK1SfQrCvvIBw=";

  nativeBuildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/share
    cp -r {node_modules,dist} $out/share
  '';

  postFixup = ''
    makeWrapper ${nodejs}/bin/node $out/bin/jitsi-excalidraw-backend \
      --add-flags dist/index.js \
      --chdir $out/share
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Excalidraw collaboration backend for Jitsi";
    homepage = "https://github.com/jitsi/excalidraw-backend";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ camillemndn ];
    mainProgram = "jitsi-excalidraw-backend";
  };
}
