{
  lib,
  stdenv,
  darwin,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lima,
  makeWrapper,
  qemu,
  testers,
  colima,
}:

buildGoModule rec {
  pname = "colima";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "abiosoft";
    repo = "colima";
    tag = "v${version}";
    hash = "sha256-H+hWmhj1raZun7oqDa2p/F1CEEdSzBFDaSSnNByM+Kw=";
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

  vendorHash = "sha256-ZwgzKCOEhgKK2LNRLjnWP6qHI4f6OGORvt3CREJf55I=";

  # disable flaky Test_extractZones
  # https://hydra.nixos.org/build/212378003/log
  excludedPackages = "gvproxy";

  env.CGO_ENABLED = 1;

  preConfigure = ''
    ldflags="-s -w -X github.com/abiosoft/colima/config.appVersion=${version} \
    -X github.com/abiosoft/colima/config.revision=$(cat .git-revision)"
  '';

  postInstall = ''
    wrapProgram $out/bin/colima \
      --prefix PATH : ${
        lib.makeBinPath [
          # Suppress warning on `colima start`: https://github.com/abiosoft/colima/issues/1333
          (lima.override {
            withAdditionalGuestAgents = true;
          })
          qemu
        ]
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

  meta = with lib; {
    description = "Container runtimes with minimal setup";
    homepage = "https://github.com/abiosoft/colima";
    license = licenses.mit;
    maintainers = with maintainers; [
      aaschmid
      tricktron
    ];
    mainProgram = "colima";
  };
}
