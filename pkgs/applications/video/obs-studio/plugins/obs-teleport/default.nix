{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script

, libjpeg_turbo
, obs-studio
}:

buildGoModule rec {
  pname = "obs-teleport";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "fzwoch";
    repo = "obs-teleport";
    rev = version;
    hash = "sha256-r9j9hePA7MFIECCwHJYLHJMUKmYQrHkJ7FM3LhXGFOY=";
  };

  vendorHash = "sha256-d7Wtc4nrVEf2TA8BI96Vj9BPOgTtfY+1dQVcEsED1ww=";

  buildInputs = [
    libjpeg_turbo
    obs-studio
  ];

  ldflags = [ "-s" "-w" ];

  env = {
    CGO_CFLAGS = toString [
      "-I${libjpeg_turbo.dev}/include"
      "-I${obs-studio}/include/obs"
    ];
    CGO_LDFLAGS = toString [
      "-L${libjpeg_turbo}/lib -lturbojpeg"
      "-L${obs-studio}/lib -lobs -lobs-frontend-api"
    ];
  };

  buildPhase = ''
    runHook preBuild

    go build -buildmode=c-shared -o obs-teleport.so .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 0644 obs-teleport.so -t $out/lib/obs-plugins

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An OBS Studio plugin for an open NDI-like replacement";
    homepage = "https://github.com/fzwoch/obs-teleport";
    license = lib.licenses.gpl2Plus;
    platforms = obs-studio.meta.platforms;
    maintainers = [ lib.maintainers.paveloom ];
  };
}
