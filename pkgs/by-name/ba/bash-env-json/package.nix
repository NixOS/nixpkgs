{
  stdenvNoCC,
  lib,
  makeWrapper,
  fetchFromGitHub,
  coreutils,
  gnused,
  jq,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bash-env-json";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "tesujimath";
    repo = "bash-env-json";
    rev = finalAttrs.version;
    hash = "sha256-cZEkYOr9z6yLPA4PSo6+hogaqb1vhWaYi/rp4asfsbM=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 bash-env-json -t $out/bin

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/bash-env-json --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        gnused
        jq
      ]
    }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Export Bash environment as JSON for import into modern shells like Elvish and Nushell";
    homepage = "https://github.com/tesujimath/bash-env-json";
    mainProgram = "bash-env-json";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jaredmontoya ];
    platforms = lib.platforms.all;
  };
})
