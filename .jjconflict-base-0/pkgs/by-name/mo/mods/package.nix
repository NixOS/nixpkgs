{
  lib,
  buildGoModule,
  installShellFiles,
  fetchFromGitHub,
  gitUpdater,
  testers,
  mods,
}:

buildGoModule rec {
  pname = "mods";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "mods";
    rev = "v${version}";
    hash = "sha256-wzLYkcgUWPzghJEhYRh7HH19Rqov1RJAxdgp3AGnOTY=";
  };

  vendorHash = "sha256-L+4vkh7u6uMm5ICMk8ke5RVY1oYeKMYWVYYq9YqpKiw=";

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
