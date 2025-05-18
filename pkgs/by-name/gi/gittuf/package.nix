{
  lib,
  fetchFromGitHub,
  buildGoModule,
  git,
  openssh,
}:

buildGoModule rec {
  pname = "gittuf";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "gittuf";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-519m73RjtEFjEZGholZ8zsjHZkJBEu2pyQqWOV0wrSc=";
  };

  vendorHash = "sha256-TFkHbIRuFPfpIE/2ALjlJX/lHcp1xYyszUiSj6CQ/U4=";

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
