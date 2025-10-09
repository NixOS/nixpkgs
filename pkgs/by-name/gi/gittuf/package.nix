{
  lib,
  fetchFromGitHub,
  buildGoModule,
  git,
  openssh,
}:

buildGoModule rec {
  pname = "gittuf";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "gittuf";
    repo = "gittuf";
    rev = "v${version}";
    hash = "sha256-/PKbo8LPvU6ZTav9n82mrj2h6z6AyJ225mCH7EfazVU=";
  };

  vendorHash = "sha256-unj9PpRkfNHWQzeCmcjppMFGAlHNcP0/j9EiGvpRzRc=";

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

  meta = {
    changelog = "https://github.com/gittuf/gittuf/blob/v${version}/CHANGELOG.md";
    description = "Security layer for Git repositories";
    homepage = "https://gittuf.dev";
    license = lib.licenses.asl20;
    mainProgram = "gittuf";
    maintainers = with lib.maintainers; [ flandweber ];
  };
}
