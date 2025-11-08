{
  buildGoModule,
  fetchFromGitHub,
  godini,
  lib,
  nix-update-script,
  testers,
}:

buildGoModule rec {
  pname = "godini";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bilbilak";
    repo = "godini";
    tag = "v${version}";
    hash = "sha256-83OAddIoJzAUXPZKGnAx8XPKrdSmtc1EIJUDmRHTU/U=";
  };

  vendorHash = "sha256-hocnLCzWN8srQcO3BMNkd2lt0m54Qe7sqAhUxVZlz1k=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/bilbilak/godini/config.Version=${version}"
  ];

  passthru = {
    tests = {
      version = testers.testVersion {
        package = godini;
        command = "godini --version";
      };
    };

    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/bilbilak/godini/blob/main/CHANGELOG.md";
    description = "INI Configuration Management Tool";
    homepage = "https://github.com/bilbilak/godini";
    license = lib.licenses.gpl3Only;
    mainProgram = "godini";
    maintainers = with lib.maintainers; [ _4r7if3x ];
    platforms = with lib.platforms; unix ++ windows;
  };
}
