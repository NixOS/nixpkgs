{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, asciidoc
, databasePath ? "/etc/secureboot"
, nix-update-script
}:

buildGoModule rec {
  pname = "sbctl";
  version = "0.15.4";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = pname;
    rev = version;
    hash = "sha256-p6Y55vtAVqBoaFbCjdF8OWu53kshEBFgodofmyyqygI=";
  };

  vendorHash = "sha256-3tlK8SDWBWF4Xsp8YJysXLGZSoMQ/zuEugBeYIaqd9Q=";

  ldflags = [ "-s" "-w" "-X github.com/foxboron/sbctl.DatabasePath=${databasePath}" "-X github.com/foxboron/sbctl.Version=${version}" ];

  nativeBuildInputs = [ installShellFiles asciidoc ];

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

  # TODO: Test of github.com/google/go-tpm-tools/simulator/internal are broken?
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Secure Boot key manager";
    mainProgram = "sbctl";
    homepage = "https://github.com/Foxboron/sbctl";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius Scrumplex ];
    # go-uefi do not support darwin at the moment:
    # see upstream on https://github.com/Foxboron/go-uefi/issues/13
    platforms = platforms.linux;
  };
}
