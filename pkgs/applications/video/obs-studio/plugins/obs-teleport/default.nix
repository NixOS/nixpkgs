{ buildGoModule
, fetchFromGitHub
, lib
, libjpeg
, nix-update-script
, obs-studio
}:

buildGoModule rec {
  pname = "obs-teleport";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "fzwoch";
    repo = "obs-teleport";
    rev = version;
    sha256 = "sha256-vT5GhZQFunQURgnFI3RSGVlwvcWEW588MuJ+Ev7IZ7w=";
  };

  vendorHash = "sha256-Po7Oj+wdBOOFI2Ws9MLZQxk4N6mE58M+3q+qNlUrqOY=";

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
    description = "OBS Studio plugin for an open NDI-like replacement";
    homepage = "https://github.com/fzwoch/obs-teleport";
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
    platforms = obs-studio.meta.platforms;
  };
}
