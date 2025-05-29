{
  lib,
  fetchFromGitHub,
  buildGoModule,
  git,
  openssh,
}:

buildGoModule rec {
  pname = "gittuf";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "gittuf";
    repo = "gittuf";
    rev = "v${version}";
    hash = "sha256-sHaQOqD8CzAb8LIOqPpvTAzdmm/NoktLnAOhVNdRIeo=";
  };

  vendorHash = "sha256-v45pMH05f6HmAcfujk25w5TN65nllLUMVlkNYm6Q/gM=";

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
