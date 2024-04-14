{ lib, fetchFromGitHub, buildGoModule, git }:

buildGoModule rec {
  pname = "gittuf";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "gittuf";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lECvgagcqBS+BVD296e6WjjSCA3vI0nfLzpLTi/7N0I=";
  };

  vendorHash = "sha256-UKhXbZXKNtMnQe7sHBOmzzXGBHuDTYeZGKnteZirskA=";

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
