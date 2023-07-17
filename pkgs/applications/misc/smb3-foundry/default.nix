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
  version = "1.2";

  src = fetchFromGitHub {
    owner = "mchlnix";
    repo = "SMB3-Foundry";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-iqqIyGp/sqWgShxk52omVcn7Q3WL2hK8sTLH4dashLE=";
  };

  patches = [ ./fix-relative-dirs.patch ];

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
    homepage = "https://github.com/mchlnix/SMB3-Foundry";
    description = "A modern Super Mario Bros. 3 Level Editor";
    changelog = "https://github.com/mchlnix/SMB3-Foundry/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
