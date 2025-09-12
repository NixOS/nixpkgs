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
  version = "0.17";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "sbctl";
    tag = version;
    hash = "sha256-7dCaWemkus2GHxILBEx5YvzdAmv89JfcPbqZZ6QwriI";
  };

  vendorHash = "sha256-gpHEJIbLnB0OiYB00rHK6OwrnHTHCj/tTVlUzuFjFKY=";

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

  postInstall = ''
    installManPage docs/sbctl.conf.5 docs/sbctl.8
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sbctl \
      --bash <($out/bin/sbctl completion bash) \
      --fish <($out/bin/sbctl completion fish) \
      --zsh <($out/bin/sbctl completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Secure Boot key manager";
    mainProgram = "sbctl";
    homepage = "https://github.com/Foxboron/sbctl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Pokeylooted
      raitobezarius
      Scrumplex
    ];
    # go-uefi does not support darwin at the moment:
    # see upstream on https://github.com/Foxboron/go-uefi/issues/13
    platforms = lib.platforms.linux;
  };
}
