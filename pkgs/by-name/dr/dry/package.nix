{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dry";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "moncho";
    repo = "dry";
    rev = "v${version}";
    hash = "sha256-JGtPX6BrB3q2EQyF6x2A5Wsn5DudOSVt3IxBAjjwlC8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-AduDbBpCoW7GmYrBPpL7wyLvwoez81qP/+mllgoHInY=";

  meta = {
    description = "Terminal application to manage Docker and Docker Swarm";
    homepage = "https://moncho.github.io/dry/";
    changelog = "https://github.com/moncho/dry/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dump_stack ];
    mainProgram = "dry";
  };
}
