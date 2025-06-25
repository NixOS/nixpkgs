{
  lib,
  fetchFromGitHub,
  buildGoModule,
  git,
  openssh,
}:

buildGoModule rec {
  pname = "gittuf";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "gittuf";
    repo = "gittuf";
    rev = "v${version}";
    hash = "sha256-atC9YsffhXvWAQzrIVwOCpcP73HhGa5x19mXm4+yLuU=";
  };

  vendorHash = "sha256-SqXwxt6TWPyuwx7gDnEUk5487z3mlYtQ+Cho+lUcN+M=";

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
