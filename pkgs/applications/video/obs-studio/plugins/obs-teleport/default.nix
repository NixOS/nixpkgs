{ buildGoModule
, fetchFromGitHub
, lib
, libjpeg
, nix-update-script
, obs-studio
}:

buildGoModule rec {
  pname = "obs-teleport";
<<<<<<< HEAD
  version = "0.6.6";
=======
  version = "0.6.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fzwoch";
    repo = "obs-teleport";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-fDLe1GbLZb/rXLiTtvcMqfQo2cG1guDCwLOEf3piPcU=";
  };

  vendorHash = "sha256-GhIFGnGnwDmuDobMlOWCRFpHTbQlRtJrqXSFwxFydG0=";
=======
    sha256 = "sha256-J3Q0AQV21jh+Pth5wXbGbryrx7Mg65rAQVapyGBls7Y=";
  };

  vendorHash = "sha256-2rlEMkdcD+46EpQhUpLIGMzqvlyMFYK/XQYV9DJZxao=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [
    libjpeg
    obs-studio
  ];

  ldflags = [ "-s" "-w" ];

  CGO_CFLAGS = "-I${obs-studio}/include/obs";
  CGO_LDFLAGS = "-L${obs-studio}/lib -lobs -lobs-frontend-api";

  buildPhase = ''
    runHook preBuild

    go build -buildmode=c-shared -o obs-teleport.so .

    runHook postBuild
  '';

  postInstall = ''
    mkdir -p $out/lib/obs-plugins
    mv obs-teleport.so $out/lib/obs-plugins
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An OBS Studio plugin for an open NDI-like replacement";
    homepage = "https://github.com/fzwoch/obs-teleport";
    maintainers = [ lib.maintainers.paveloom ];
    license = lib.licenses.gpl2Plus;
    platforms = obs-studio.meta.platforms;
  };
}
