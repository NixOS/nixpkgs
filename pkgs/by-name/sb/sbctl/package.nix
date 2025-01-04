{
  lib,
  buildGoModule,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  asciidoc,
  databasePath ? "/etc/secureboot",
  nix-update-script,
}:

buildGoModule rec {
  pname = "sbctl";
  version = "0.16";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "sbctl";
    rev = "refs/tags/${version}";
    hash = "sha256-BLSvjo6GCqpECJPJtQ6C2zEz1p03uyvxTYa+DoxZ78s=";
  };

  vendorHash = "sha256-srfZ+TD93szabegwtzLTjB+uo8aj8mB4ecQ9m8er00A=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/foxboron/sbctl.DatabasePath=${databasePath}"
    "-X github.com/foxboron/sbctl.Version=${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    asciidoc
  ];

  postBuild = ''
    make docs/sbctl.conf.5 docs/sbctl.8
  '';

  checkFlags = [
    # https://github.com/Foxboron/sbctl/issues/343
    "-skip"
    "github.com/google/go-tpm-tools/.*"
  ];

  postInstall =
    ''
      installManPage docs/sbctl.conf.5 docs/sbctl.8
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
    maintainers = with maintainers; [
      raitobezarius
      Scrumplex
    ];
    # go-uefi do not support darwin at the moment:
    # see upstream on https://github.com/Foxboron/go-uefi/issues/13
    platforms = platforms.linux;
  };
}
