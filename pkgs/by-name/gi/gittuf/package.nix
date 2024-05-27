{ lib, fetchFromGitHub, buildGoModule, git }:

buildGoModule rec {
  pname = "gittuf";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "gittuf";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BXqxVtdxUbcl2cK4kYEBZIbMCKOjPvuoTnDh8L6+mO8=";
  };

  vendorHash = "sha256-yRUgtUeoTthxSGZ6VX/MOVeY0NUXq0Nf+XlysHqcpWw=";

  ldflags = [ "-X github.com/gittuf/gittuf/internal/version.gitVersion=${version}" ];

  nativeCheckInputs = [ git ];
  checkFlags = [ "-skip=TestLoadRepository" ];

  postInstall = "rm $out/bin/cli"; # remove gendoc cli binary

  meta = with lib; {
    changelog = "https://github.com/gittuf/gittuf/blob/v${version}/CHANGELOG.md";
    description = "A security layer for Git repositories";
    homepage = "https://gittuf.dev";
    license = licenses.asl20;
    mainProgram = "gittuf";
    maintainers = with maintainers; [ flandweber ];
  };
}
