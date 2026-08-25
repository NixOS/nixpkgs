{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
}:

rustPlatform.buildRustPackage rec {
  pname = "sshx";
  version = "0.4.1";

  cargoHash = "sha256-QftBUGDQvCSHoOBLnEzNOe1dMTpVTvMDXNp5qZr0C2M=";

  src = fetchFromGitHub {
    owner = "ekzhang";
    repo = "sshx";
    tag = "v${version}";
    hash = "sha256-+IHV+dJb/j1/tmdqDXo6bqhvj3nBQ7i4AsUeHFA3+NU=";
  };

  nativeBuildInputs = [ protobuf ];

  cargoBuildFlags = [
    "--package"
    "sshx"
  ];

  cargoTestFlags = cargoBuildFlags;

  meta = {
    description = "Fast, collaborative live terminal sharing over the web";
    homepage = "https://github.com/ekzhang/sshx";
    changelog = "https://github.com/ekzhang/sshx/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pinpox
    ];
    mainProgram = "sshx";
  };
}
