{ lib, fetchFromGitHub, buildGoModule, installShellFiles, symlinkJoin }:

let
  tctl-next = buildGoModule rec {
    pname = "tctl-next";
    version = "0.9.0";

    src = fetchFromGitHub {
      owner = "temporalio";
      repo = "cli";
      rev = "v${version}";
      hash = "sha256-zgi1wNx7fWf/iFGKaVffcXnC90vUz+mBT6HhCGdXMa0=";
    };

    vendorHash = "sha256-muTNwK2Sb2+0df/6DtAzT14gwyuqa13jkG6eQaqhSKg=";

    nativeBuildInputs = [ installShellFiles ];

    excludedPackages = [ "./cmd/docgen" "./tests" ];

    ldflags = [
      "-s"
      "-w"
      "-X github.com/temporalio/cli/headers.Version=${version}"
    ];

    preCheck = ''
      export HOME=$(mktemp -d)
    '';

    postInstall = ''
      installShellCompletion --cmd temporal \
        --bash <($out/bin/temporal completion bash) \
        --zsh <($out/bin/temporal completion zsh)
    '';
  };

  tctl = buildGoModule rec {
    pname = "tctl";
    version = "1.18.0";

    src = fetchFromGitHub {
      owner = "temporalio";
      repo = "tctl";
      rev = "v${version}";
      hash = "sha256-LcBKkx3mcDOrGT6yJx98CSgxbwskqGPWqOzHWOu6cig=";
    };

    vendorHash = "sha256-BUYEeC5zli++OxVFgECJGqJkbDwglLppSxgo+4AqOb0=";

    nativeBuildInputs = [ installShellFiles ];

    excludedPackages = [ "./cmd/copyright" ];

    ldflags = [ "-s" "-w" ];

    preCheck = ''
      export HOME=$(mktemp -d)
    '';

    postInstall = ''
      installShellCompletion --cmd tctl \
        --bash <($out/bin/tctl completion bash) \
        --zsh <($out/bin/tctl completion zsh)
    '';
  };
in
symlinkJoin rec {
  pname = "temporal-cli";
  inherit (tctl) version;
  name = "${pname}-${version}";

  paths = [
    tctl-next
    tctl
  ];

  meta = with lib; {
    description = "Temporal CLI";
    homepage = "https://temporal.io";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "temporal";
  };
}
