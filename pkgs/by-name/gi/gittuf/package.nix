{ lib, fetchFromGitHub, buildGoModule, git, openssh }:

buildGoModule rec {
  pname = "gittuf";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "gittuf";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mes+6Bs6KhLkcHRzI07ciT1SuSJU/YxjXt0MCDeVCUk=";
  };

  vendorHash = "sha256-7z7+ycV6e24JUlLIxRCAgJwxRcRgGWBYPgbXgGqatEE=";

  ldflags = [ "-X github.com/gittuf/gittuf/internal/version.gitVersion=${version}" ];

  nativeCheckInputs = [ git openssh ];
  checkFlags = [ "-skip=TestLoadRepository" "-skip=TestSSH" ];

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
