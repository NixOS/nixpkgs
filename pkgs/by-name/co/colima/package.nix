{
  lib,
  stdenv,
  darwin,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  krunkit,
  lima-full,
  makeWrapper,
  procps,
  qemu,
  testers,
  colima,
}:

buildGoModule (finalAttrs: {
  pname = "colima";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "abiosoft";
    repo = "colima";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rs+kEtOvJ80vnZBhjTt9zNskLQRywzdgzr14j7COnWU=";
    # We need the git revision
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.git-revision
      rm -rf $out/.git
    '';
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.DarwinTools ];

  vendorHash = "sha256-j1RuG3CTGfVNfT/v+C2pZgb58c9cxa2op3LA/F5rNWo=";

  # disable flaky Test_extractZones
  # https://hydra.nixos.org/build/212378003/log
  excludedPackages = "gvproxy";

  env.CGO_ENABLED = 1;

  postPatch = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    substituteInPlace cmd/daemon/daemon.go \
      --replace-fail '/usr/bin/pkill' '${lib.getExe' procps "pkill"}'

    substituteInPlace daemon/process/vmnet/vmnet.go \
      --replace-fail '/usr/bin/pkill' '${lib.getExe' procps "pkill"}'
  '';

  preConfigure = ''
    ldflags="-s -w -X github.com/abiosoft/colima/config.appVersion=${finalAttrs.version} \
    -X github.com/abiosoft/colima/config.revision=$(cat .git-revision)"
  '';

  postInstall = ''
    wrapProgram $out/bin/colima \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            # Suppress warning on `colima start`: https://github.com/abiosoft/colima/issues/1333
            lima-full
            qemu
          ]
          ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform krunkit) krunkit
        )
      }

    installShellCompletion --cmd colima \
      --bash <($out/bin/colima completion bash) \
      --fish <($out/bin/colima completion fish) \
      --zsh <($out/bin/colima completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = colima;
    command = "HOME=$(mktemp -d) colima version";
  };

  meta = {
    description = "Container runtimes with minimal setup";
    homepage = "https://github.com/abiosoft/colima";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aaschmid
      tricktron
    ];
    mainProgram = "colima";
  };
})
