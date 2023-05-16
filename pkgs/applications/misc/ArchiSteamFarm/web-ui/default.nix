{ lib, fetchFromGitHub, buildNpmPackage, nodePackages, ArchiSteamFarm }:

buildNpmPackage {
  pname = "asf-ui";
  inherit (ArchiSteamFarm) version;

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
<<<<<<< HEAD
    rev = "578e8eacf9eb0367d864ed741017dce23415c1be";
    hash = "sha256-It76gyrTPiZFEj9aSFKwAsj2jhV3zacJS8CNl4sr7OU=";
  };

  npmDepsHash = "sha256-7404OPGhF7bgdvtyfLM/7zRXGUWPr2RLUCzeaHcCj0A=";
=======
    rev = "114c390c92a889b86cf560def28fb8f39bc4fe54";
    sha256 = "1ajmi2l6xhv3nlnag2kmkblny925irp4gngdc3mniiimw364p826";
  };

  npmDepsHash = "sha256-AY1DFuZkB8tOQd2FzHuNZ31rtLlWujP+3AqsMMB2BhU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -rv dist/* $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "The official web interface for ASF";
<<<<<<< HEAD
    license = licenses.asl20;
=======
    license = licenses.apsl20;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/JustArchiNET/ASF-ui";
    inherit (ArchiSteamFarm.meta) maintainers platforms;
  };
}
