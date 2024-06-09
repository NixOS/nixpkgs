{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "hexxy";
  version = "0-unstable-2024-02-24";
  src = fetchFromGitHub {
    owner = "sweetbbak";
    repo = "hexxy";
    # upstream does not publish releases, i.e., there are no tags
    rev = "30e0aa5549bbafeb8204fe34b0d37019f9acc975";
    hash = "sha256-KBgxZD95UT7i/eYeKLm0LVLliKgK/KiJYXVY9zzwbvk=";
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
