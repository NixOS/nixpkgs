{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, curl
, perl
, git
, nix-update-script
, testers
, pint
}:

buildGoModule rec {
  pname = "pint";
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "pint";
    rev = "v${version}";
    hash = "sha256-d3KZPPeQJBqdrr81YLusYHc5jLChC1Rf5SYeP/QMeo8=";
  };

  vendorHash = "sha256-9tJL33Qtu0xAmRnAP0BwM6CIfGs+GEG864e89XrpfLM=";

  nativeBuildInputs = [ makeWrapper ];

  subPackages = [ "cmd/pint" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
  ];

  preCheck = ''
    substituteInPlace internal/git/git.go \
      --replace '.Command("git"' '.Command("${lib.getExe git}"'

    substituteInPlace cmd/pint/tests/* \
      --replace 'curl ' '${lib.getExe curl} ' \
      --replace 'perl' '${lib.getExe perl}' \
      --replace 'exec git' 'exec ${lib.getExe git}'
  '';


  postInstall = ''
    wrapProgram $out/bin/pint \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = pint;
      command = "pint version";
    };
  };

  meta = with lib; {
    changelog = "https://github.com/cloudflare/pint/releases/tag/${src.rev}";
    description = "Prometheus rule linter/validator";
    homepage = "https://github.com/cloudflare/pint";
    license = licenses.asl20;
    maintainers = with maintainers; [ gaelreyrol ];
    mainProgram = "pint";
  };
}
