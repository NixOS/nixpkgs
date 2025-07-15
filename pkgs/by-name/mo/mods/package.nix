{
  lib,
  stdenv,
  buildGoModule,
  installShellFiles,
  fetchFromGitHub,
  gitUpdater,
  testers,
  mods,
}:

buildGoModule rec {
  pname = "mods";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "mods";
    rev = "v${version}";
    hash = "sha256-CT90uMQc0quQK/vCeLiHH8taEkCSDIcO7Q3aA+oaNmY=";
  };

  # Otherwise checks fail with `panic: open /etc/protocols: operation not permitted` when sandboxing is enabled on Darwin
  # https://github.com/NixOS/nixpkgs/pull/381645#issuecomment-2656211797
  modPostBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace vendor/modernc.org/libc/honnef.co/go/netdb/netdb.go \
      --replace '!os.IsNotExist(err)' '!os.IsNotExist(err) && !os.IsPermission(err)'
  '';

  vendorHash = "sha256-jtSuSKy6GpWrJAXVN2Acmtj8klIQrgJjNwgyRZIyqyY=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  # These tests require internet access.
  checkFlags = [ "-skip=^TestLoad/http_url$|^TestLoad/https_url$" ];

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = ".(rc|beta).*";
    };

    tests.version = testers.testVersion {
      package = mods;
      command = "HOME=$(mktemp -d) mods -v";
    };
  };

  postInstall = ''
    export HOME=$(mktemp -d)
    $out/bin/mods man > mods.1
    $out/bin/mods completion bash > mods.bash
    $out/bin/mods completion fish > mods.fish
    $out/bin/mods completion zsh > mods.zsh

    installManPage mods.1
    installShellCompletion mods.{bash,fish,zsh}
  '';

  meta = {
    description = "AI on the command line";
    homepage = "https://github.com/charmbracelet/mods";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dit7ya
      caarlos0
    ];
    mainProgram = "mods";
  };
}
