{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "hexxy";
  version = "0-unstable-2024-09-29";
  src = fetchFromGitHub {
    owner = "sweetbbak";
    repo = "hexxy";
    # upstream does not publish releases, i.e., there are no tags
    rev = "36174e436f9d57421b9e9515db32ca1425c382bd";
    hash = "sha256-5r8yaKlRkIcZXubHBMhdGV0u52rs2WnEaWatm+D56Fs=";
  };

  vendorHash = "sha256-qkBpSVLWZPRgS9bqOVUWHpyj8z/nheQJON3vJOwPUj4=";
  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "A modern and beautiful alternative to xxd and hexdump";
    homepage = "https://github.com/sweetbbak/hexxy";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.NotAShelf ];
    mainProgram = "hexxy";
  };
}
