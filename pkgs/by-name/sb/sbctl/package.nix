{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  asciidoc,
  databasePath ? "/etc/secureboot",
  nix-update-script,
}:

buildGoModule rec {
  pname = "sbctl";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = pname;
    rev = version;
    hash = "sha256-1TprUr+bLPOlMpe4ReV1S/QbVsA8Q7QIOcLczEaSyAQ=";
  };

  patches = [
    ./fix-go-module.patch
  ];

  vendorHash = "sha256-LuSewWK/sxaHibJ6a05PM9CPen8J+MJD6lwk4SNOWSA=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/foxboron/sbctl.DatabasePath=${databasePath}"
  ];

  nativeBuildInputs = [
    installShellFiles
    asciidoc
  ];

  postBuild = ''
    make docs/sbctl.8
  '';

  postInstall = ''
    installManPage docs/sbctl.8

    installShellCompletion --cmd sbctl \
    --bash <($out/bin/sbctl completion bash) \
    --fish <($out/bin/sbctl completion fish) \
    --zsh <($out/bin/sbctl completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Secure Boot key manager";
    mainProgram = "sbctl";
    homepage = "https://github.com/Foxboron/sbctl";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
    # go-uefi do not support darwin at the moment:
    # see upstream on https://github.com/Foxboron/go-uefi/issues/13
    platforms = platforms.linux;
  };
}
