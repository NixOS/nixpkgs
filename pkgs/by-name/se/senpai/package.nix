{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  installShellFiles,
  scdoc,
}:

buildGoModule rec {
  pname = "senpai";
  version = "0.3.0";

  src = fetchFromSourcehut {
    owner = "~delthas";
    repo = "senpai";
    rev = "v${version}";
    sha256 = "sha256-A5kBrJJi+RcSpB0bi2heKzNl5LjdeT9h2Pc9kKXDg1A=";
  };

  vendorHash = "sha256-kKYee1QJX7N101MTikHUbX+AqZ2NhM4soE4JAAOdAPI=";

  patches = [
    # fix build failures, submitted upstream https://lists.sr.ht/~delthas/senpai-dev/patches/48581
    ./bump-go-version.patch
  ];

  subPackages = [
    "cmd/senpai"
  ];

  nativeBuildInputs = [
    scdoc
    installShellFiles
  ];

  postInstall = ''
    scdoc < doc/senpai.1.scd > doc/senpai.1
    scdoc < doc/senpai.5.scd > doc/senpai.5
    installManPage doc/senpai.*
  '';

  meta = with lib; {
    description = "Your everyday IRC student";
    mainProgram = "senpai";
    homepage = "https://sr.ht/~taiite/senpai/";
    changelog = "https://git.sr.ht/~delthas/senpai/refs/v${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ malte-v ];
  };
}
