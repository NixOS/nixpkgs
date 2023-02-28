{ lib
, stdenv
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
, lima-drv ? if stdenv.isDarwin then lima-bin else lima
}:

buildGoModule rec {
  pname = "colima";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "abiosoft";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xw+Yy9KejVkunOLJdmfXstP7aDrl3j0OZjCaf6pyL1U=";
    # We need the git revision
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.git-revision
      rm -rf $out/.git
    '';
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  vendorSha256 = "sha256-Iz1LYL25NpkztTM86zrLwehub8FzO1IlwZqCPW7wDN4=";

  CGO_ENABLED = 1;

  preConfigure = ''
    ldflags="-s -w -X github.com/abiosoft/colima/config.appVersion=${version} \
    -X github.com/abiosoft/colima/config.revision=$(cat .git-revision)"
  '';

  subPackages = [ "cmd/colima" ];

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
  };
}
