{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "moar";
  version = "1.33.0";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "moar";
    rev = "v${version}";
    hash = "sha256-+06cup9iG+iMyluQPzUQ7vrnFHoeU4KNHGra3AsRRw0=";
  };

  vendorHash = "sha256-ComKeqnw1PvDaCRVXfInRjSzhyZWGkD/hp5piwhwxds=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ./moar.1
  '';

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.versionString=v${version}"
  ];

  meta = with lib; {
    description = "Nice-to-use pager for humans";
    homepage = "https://github.com/walles/moar";
    license = licenses.bsd2WithViews;
    mainProgram = "moar";
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
