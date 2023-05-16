<<<<<<< HEAD
{ lib, fetchFromGitHub, buildGoModule, installShellFiles, symlinkJoin, stdenv }:

let
  metaCommon = with lib; {
    description = "Command-line interface for running Temporal Server and interacting with Workflows, Activities, Namespaces, and other parts of Temporal";
    homepage = "https://docs.temporal.io/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
  };

  overrideModAttrs = old: {
    # https://gitlab.com/cznic/libc/-/merge_requests/10
    postBuild = ''
      patch -p0 < ${./darwin-sandbox-fix.patch}
    '';
  };

  tctl-next = buildGoModule rec {
    pname = "tctl-next";
    version = "0.9.0";
=======
{ lib, fetchFromGitHub, buildGoModule, installShellFiles, symlinkJoin }:

let
  tctl-next = buildGoModule rec {
    pname = "tctl-next";
    version = "0.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    src = fetchFromGitHub {
      owner = "temporalio";
      repo = "cli";
      rev = "v${version}";
<<<<<<< HEAD
      hash = "sha256-zgi1wNx7fWf/iFGKaVffcXnC90vUz+mBT6HhCGdXMa0=";
    };

    vendorHash = "sha256-EX1T3AygarJn4Zae2I8CHQrZakmbNF1OwE4YZFF+nKc=";

    inherit overrideModAttrs;

    nativeBuildInputs = [ installShellFiles ];

    excludedPackages = [ "./cmd/docgen" "./tests" ];
=======
      hash = "sha256-yQnFw3uYGKrTevGFVZNgkWwKCCWiGy0qwJJOmnMpTJQ=";
    };

    vendorHash = "sha256-ld59ADHnlgsCA2mzVhdq6Vb2aa9rApvFxs3NpHiCKxo=";

    nativeBuildInputs = [ installShellFiles ];

    excludedPackages = [ "./cmd/docgen" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    ldflags = [
      "-s"
      "-w"
      "-X github.com/temporalio/cli/headers.Version=${version}"
    ];

<<<<<<< HEAD
    # Tests fail with x86 on macOS Rosetta 2
    doCheck = !(stdenv.isDarwin && stdenv.hostPlatform.isx86_64);

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    preCheck = ''
      export HOME=$(mktemp -d)
    '';

    postInstall = ''
      installShellCompletion --cmd temporal \
        --bash <($out/bin/temporal completion bash) \
        --zsh <($out/bin/temporal completion zsh)
    '';
<<<<<<< HEAD

    __darwinAllowLocalNetworking = true;

    meta = metaCommon // {
      mainProgram = "temporal";
    };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
    vendorHash = "sha256-5wCIY95mJ6+FCln4yBu+fM4ZcsxBGcXkCvxjGzt0+dM=";

    inherit overrideModAttrs;
=======
    vendorHash = "sha256-BUYEeC5zli++OxVFgECJGqJkbDwglLppSxgo+4AqOb0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD

    __darwinAllowLocalNetworking = true;

    meta = metaCommon // {
      mainProgram = "tctl";
    };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  passthru = { inherit tctl tctl-next; };

  meta = metaCommon // {
    mainProgram = "temporal";
    platforms = lib.unique (lib.concatMap (drv: drv.meta.platforms) paths);
=======
  meta = with lib; {
    description = "Temporal CLI";
    homepage = "https://temporal.io";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "temporal";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
