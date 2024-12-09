{ lib
, stdenv
, darwin
, buildGoModule
, fetchFromGitHub
, installShellFiles
, lima
, lima-bin
, makeWrapper
, qemu
, testers
, colima
  # use lima-bin on darwin to support native macOS virtualization
  # https://github.com/NixOS/nixpkgs/pull/209171
, lima-drv ? if stdenv.hostPlatform.isDarwin then lima-bin else lima
}:

buildGoModule rec {
  pname = "colima";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "abiosoft";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nWJnk2m0ETXYjiUIDSN1hK9FXopn3AZz7TJ8nzSLe1E=";
    # We need the git revision
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.git-revision
      rm -rf $out/.git
    '';
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.DarwinTools ];

  vendorHash = "sha256-caqQA+vDtC5s9qehMIMAcl8JD3Ls2wCSfOpUFPFQ9zY=";

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
      --prefix PATH : ${lib.makeBinPath [ lima-drv qemu ]}

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
    maintainers = with maintainers; [ aaschmid tricktron ];
    mainProgram = "colima";
  };
}
