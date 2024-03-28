{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ryzen_monitor_ng";
  version = "2.0.5-unstable-2023-11-05";

  # Upstream has not updated ryzen_smu header version
  # This fork corrects ryzen_smu header version and
  # adds support for Matisse AMD CPUs.
  src = fetchFromGitHub {
    owner = "plasmin";
    repo = "ryzen_monitor_ng";
    rev = "8b7854791d78de731a45ce7d30dd17983228b7b1";
    sha256 = "sha256-fcW2fEsCFliRnMFnboR0jchzVIlCYbr2AE6AS06cb6o=";
  };

  buildPhase = ''
    runHook preBuild

    make clean
    rm src/ryzen_monitor
    make

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    mv ./src/ryzen_monitor $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Access Ryzen SMU information exposed by the ryzen_smu driver";
    homepage = "https://github.com/mann1x/ryzen_monitor_ng";
    license = licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ phdyellow ];
    mainProgram = "ryzen_monitor";
  };
}
