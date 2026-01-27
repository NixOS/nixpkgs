{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "sif";
  version = "0-unstable-2026-01-03";

  src = fetchFromGitHub {
    owner = "vmfunc";
    repo = "sif";
    rev = "6df11f82840d3bf28e94e05dd76a984442f36d58";
    hash = "sha256-IoP3sfjim6DCUxdL3Lgm1Z3zrIqnWZPNjDn0wVjLtV0=";
  };

  vendorHash = "sha256-ztKXnOjZS/jMxsRjtF0rIZ3lKv4YjMdZd6oQFRuAtR4=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Modular pentesting toolkit written in Go";
    homepage = "https://github.com/vmfunc/sif";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ andrewgazelka ];
    mainProgram = "sif";
  };
}
