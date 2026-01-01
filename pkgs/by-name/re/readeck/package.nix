{
  lib,
  fetchFromGitea,
  fetchNpmDeps,
  buildGoModule,
  nodejs,
  npmHooks,
  python3,
}:

buildGoModule rec {
  pname = "readeck";
<<<<<<< HEAD
  version = "0.21.5";
=======
  version = "0.21.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "readeck";
    repo = "readeck";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-9M9Bgl1CJ35x/Onlk5xUNCFkZKW40efF6qMOM+2/HR0=";
  };

  postPatch = ''
    sed -i -e '/^go /s/1.25.5/1.25.4/' go.mod
  '';

=======
    hash = "sha256-d4FLyD2uOngUANc7fai8j0wZSY1ISS18JEBDxCqXdQw=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    (python3.withPackages (ps: with ps; [ babel ]))
  ];

  npmRoot = "web";

  NODE_PATH = "$npmDeps";

  preBuild = ''
    make generate
  '';

  subPackages = [ "." ];

  tags = [
    "netgo"
    "osusergo"
    "sqlite_omit_load_extension"
    "sqlite_foreign_keys"
    "sqlite_json1"
    "sqlite_fts5"
    "sqlite_secure_delete"
  ];

  ldflags = [
    "-X"
    "codeberg.org/readeck/readeck/configs.version=${version}"
    "-X"
    "codeberg.org/readeck/readeck/configs.buildTimeStr=1970-01-01T08:00:00Z"
  ];

  overrideModAttrs = oldAttrs: {
    # Do not add `npmConfigHook` to `goModules`
    nativeBuildInputs = lib.remove npmHooks.npmConfigHook oldAttrs.nativeBuildInputs;
    # Do not run `preBuild` when building `goModules`
    preBuild = null;
  };

  npmDeps = fetchNpmDeps {
    src = "${src}/web";
<<<<<<< HEAD
    hash = "sha256-znUKRaUdx6GXD2YL6hs0iveaAAHQ8H9n4NHZFi331+g=";
  };

  vendorHash = "sha256-2MB7v5oG/LcEKtgbFNxPXSI8TljpbqYUrI7pvu7m+e8=";
=======
    hash = "sha256-XT+4IR1xVXiDY4wx2smt0pcNUx6UFoXYq+zxvbGsQ8A=";
  };

  vendorHash = "sha256-IWRlruj+zYixCRgbaf7QYBeCGwzf0qRY8OFa4s/PzME=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Web application that lets you save the readable content of web pages you want to keep forever";
    mainProgram = "readeck";
    homepage = "https://readeck.org/";
    changelog = "https://codeberg.org/readeck/readeck/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      julienmalka
      linsui
    ];
  };
}
