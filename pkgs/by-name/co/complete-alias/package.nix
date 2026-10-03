{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "complete-alias";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "cykerway";
    repo = "complete-alias";
    tag = version;
    hash = "sha256-fZisrhdu049rCQ5Q90sFWFo8GS/PRgS29B1eG8dqlaI=";
  };

  buildPhase = ''
    runHook preBuild

    # required for the patchShebangs setup hook
    chmod +x complete_alias

    patchShebangs complete_alias

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r complete_alias "$out"/bin

    runHook postInstall
  '';

  meta = {
    description = "Automagical shell alias completion";
    homepage = "https://github.com/cykerway/complete-alias";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ tuxinaut ];
    mainProgram = "complete_alias";
  };
}
