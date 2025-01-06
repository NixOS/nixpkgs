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
    repo = pname;
    rev = version;
    sha256 = "18lmdb3inphxyjv08ing5wckqnjq0m5zfl0f15mqzlvf2ypar63x";
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

  meta = with lib; {
    description = "Automagical shell alias completion";
    homepage = "https://github.com/cykerway/complete-alias";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ tuxinaut ];
    mainProgram = "complete_alias";
  };
}
