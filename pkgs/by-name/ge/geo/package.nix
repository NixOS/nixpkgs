{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  geo,
}:

buildGoModule rec {
  pname = "geo";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "geo";
    rev = "v${version}";
    hash = "sha256-lwFBevf3iP90LgnfUqweCjPBJPr2vMFtRqQXXUC+cRA=";
  };

  postPatch = ''
    substituteInPlace constant.go \
      --replace-fail 'Version = "0.1"' 'Version = "${version}"'
  '';

  vendorHash = "sha256-FXvuojlMZRzi8TIQ2aPiDH7F9c+2dpe4PYzYWljfUIc=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = geo;
      command = "${lib.getExe geo} --help";
      version = "v${version}";
    };
  };

  meta = {
    description = "Easy way to manage all your Geo resources";
    homepage = "https://github.com/MetaCubeX/geo";
    changelog = "https://github.com/MetaCubeX/geo/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "geo";
  };
}
