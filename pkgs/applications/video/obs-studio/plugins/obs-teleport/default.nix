{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libjpeg,
  nix-update-script,
  obs-studio,
}:

buildGoModule rec {
  pname = "obs-teleport";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "fzwoch";
    repo = "obs-teleport";
    rev = version;
    sha256 = "sha256-r1CB9wzw1tuRHWpx5PXyuh1y3Tue34Wpgys7LSEh62s=";
  };

  vendorHash = "sha256-o7PL3qnZ13L8+7mVx2yyDIlw/0s+NHNwy9DaRZxVKLc=";

  buildInputs = [
    libjpeg
    obs-studio
  ];

  ldflags = [
    "-s"
    "-w"
  ];

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
    description = "OBS Studio plugin for an open NDI-like replacement";
    homepage = "https://github.com/fzwoch/obs-teleport";
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
    platforms = obs-studio.meta.platforms;
  };
}
