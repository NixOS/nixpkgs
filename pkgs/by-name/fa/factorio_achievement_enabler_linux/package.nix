{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "factorio_achievement_enabler_linux";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "UnlegitSenpaii";
    repo = "FAE_Linux";
    rev = "v${version}";
    hash = "sha256-lm/s9rc4/2TIT2mzIPwdFoPB9GZm4qluK2yVoL7KwnE";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 out/bin/FAE_Linux $out/bin/fae_linux

    runHook postInstall
  '';

  meta = {
    description = "Factorio Achievement Enabler for Linux";
    homepage = "https://github.com/UnlegitSenpaii/FAE_Linux";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ henriquelay ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "fae_linux";
  };
}
