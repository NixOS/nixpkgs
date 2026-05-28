{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "simplelogin-cli";
  version = "0.3.0";

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "mexcool";
    repo = "simplelogin-cli";
    rev = "v${version}";
    hash = "sha256-xArmFEBxigd7/iPp4gaQ6iU3jyKbvSf3NpIl4XcYiQ0=";
  };

  vendorHash = "sha256-P0+WT/1HKxSLmfDaIeQ8JThPbBuaf59rZjJjxuI+lzg=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    $out/bin/gen-man && rm $out/bin/gen-man
    installManPage man/*.[1-9]
  '';

  meta = {
    description = "SimpleLogin cli to manage email aliases from the terminal.";
    homepage = "https://github.com/mexcool/simplelogin-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ afh ];
    mainProgram = "simplelogin-cli";
  };
}
