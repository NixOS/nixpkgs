{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  bintools,
  file,
  getopt,
  patchelf,
}:

stdenvNoCC.mkDerivation {
  name = "autopatchelf";
  version = "0-unstable-2019-06-15";

  src = fetchFromGitHub {
    owner = "svanderburg";
    repo = "nix-patchtools";
    rev = "6cc6fa4e0d8e1f24be155f6c60af34c8756c9828";
    hash = "sha256-anuSZw0wcKtTxszBZh2Ob/eOftixEZzrNC1sCaQzznk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 $src/autopatchelf $out/bin
    patchShebangs $out/bin
    wrapProgram $out/bin/autopatchelf --prefix PATH : ${
      lib.makeBinPath [
        bintools
        getopt
        file
        patchelf
      ]
    }

    runHook postInstall
  '';

  meta = {
    description = "Automatically patch ELF binaries to fix issues with RPATH and DT_RUNPATH";
    homepage = "https://github.com/svanderburg/nix-patchtools";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sander
      pandapip1
    ];
  };
}
