{
  lib,
  stdenv,
  darwin,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lima,
  lima-bin,
  makeWrapper,
  qemu,
  testers,
  colima,
  # use lima-bin on darwin to support native macOS virtualization
  # https://github.com/NixOS/nixpkgs/pull/209171
  lima-drv ? if stdenv.isDarwin then lima-bin else lima,
}:

buildGoModule rec {
  pname = "colima";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "abiosoft";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7kaZ55Uhvx8V75IgURD03fLoAd/O/+2h/7tv9XiqnX4=";
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
  ] ++ lib.optionals stdenv.isDarwin [ darwin.DarwinTools ];

  vendorHash = "sha256-FPcz109zQBHaS/bIl78rVeiEluR1PhrJhgs21Ex6qEg=";

  # disable flaky Test_extractZones
  # https://hydra.nixos.org/build/212378003/log
  excludedPackages = "gvproxy";

  CGO_ENABLED = 1;

  preConfigure = ''
    ldflags="-s -w -X github.com/abiosoft/colima/config.appVersion=${version} \
    -X github.com/abiosoft/colima/config.revision=$(cat .git-revision)"
  '';

  postInstall = ''
    wrapProgram $out/bin/colima \
      --prefix PATH : ${
        lib.makeBinPath [
          lima-drv
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
