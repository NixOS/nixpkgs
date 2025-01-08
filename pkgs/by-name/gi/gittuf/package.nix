{
  lib,
  fetchFromGitHub,
  buildGoModule,
  git,
  openssh,
}:

buildGoModule rec {
  pname = "gittuf";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "gittuf";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0HxjCHwYhJkDfMt+8kzOAfZVhlprXcKpJSpWIQreTK4=";
  };

  vendorHash = "sha256-fXDbXyMKTiw2PugW3WPzyMupfXCgObm9MkJfix0mKaM=";

  ldflags = [ "-X github.com/gittuf/gittuf/internal/version.gitVersion=${version}" ];

  nativeCheckInputs = [
    git
    openssh
  ];
  checkFlags = [
    "-skip=TestLoadRepository"
    "-skip=TestSSH"
  ];

  postInstall = "rm $out/bin/cli"; # remove gendoc cli binary

  meta = with lib; {
    changelog = "https://github.com/gittuf/gittuf/blob/v${version}/CHANGELOG.md";
    description = "Security layer for Git repositories";
    homepage = "https://gittuf.dev";
    license = licenses.asl20;
    mainProgram = "gittuf";
    maintainers = with maintainers; [ flandweber ];
  };
}
