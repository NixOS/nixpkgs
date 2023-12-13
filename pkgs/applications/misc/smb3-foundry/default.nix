{ lib
, stdenv
, fetchFromGitHub
, python3
, makeWrapper
}:

let
  pythonEnv = (python3.withPackages (ps: with ps; [
    pyside6
    py65
    qdarkstyle
  ]));
in
stdenv.mkDerivation (finalAttrs: {
  pname = "smb3-foundry";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "mchlnix";
    repo = "SMB3-Foundry";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-8cf7VhvC372Cqi94n2FSHcoCGblpZoZvBXcXq5jU6CY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/app
    cp -R smb3parse foundry scribe data doc VERSION smb3-foundry.py smb3-scribe.py $out/app

    makeWrapper ${pythonEnv}/bin/python $out/bin/smb3-foundry \
          --add-flags "$out/app/smb3-foundry.py"
    makeWrapper ${pythonEnv}/bin/python $out/bin/smb3-scribe \
          --add-flags "$out/app/smb3-scribe.py"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/mchlnix/SMB3-Foundry/releases/tag/${finalAttrs.version}";
    description = "A modern Super Mario Bros. 3 Level Editor";
    homepage = "https://github.com/mchlnix/SMB3-Foundry";
    license = lib.licenses.gpl3Only;
    mainProgram = "smb3-foundry";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.unix;
  };
})
