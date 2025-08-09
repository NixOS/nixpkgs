{
  lib,
  fetchFromGitea,
  fetchNpmDeps,
  buildGoModule,
  nodejs,
  npmHooks,
  python3,
}:

let
  file-compose = buildGoModule {
    pname = "file-compose";
    version = "unstable-2023-10-21";

    src = fetchFromGitea {
      domain = "codeberg.org";
      owner = "readeck";
      repo = "file-compose";
      rev = "afa938655d412556a0db74b202f9bcc1c40d8579";
      hash = "sha256-rMANRqUQRQ8ahlxuH1sWjlGpNvbReBOXIkmBim/wU2o=";
    };

    vendorHash = "sha256-Qwixx3Evbf+53OFeS3Zr7QCkRMfgqc9hUA4eqEBaY0c=";
  };
in

buildGoModule rec {
  pname = "readeck";
  version = "0.19.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "readeck";
    repo = "readeck";
    tag = version;
    hash = "sha256-gTU1RMd6b1wLIqI8VGa1Fn8+ydhW76E8ft5du71E1zM=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    (python3.withPackages (ps: with ps; [ babel ]))
  ];

  npmRoot = "web";

  NODE_PATH = "$npmDeps";

  preBuild = ''
    make web-build
    python3 locales/messages.py compile
    ${file-compose}/bin/file-compose -format json docs/api/api.yaml docs/assets/api.json
    go run ./tools/docs docs/src docs/assets
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
  ];

  overrideModAttrs = oldAttrs: {
    # Do not add `npmConfigHook` to `goModules`
    nativeBuildInputs = lib.remove npmHooks.npmConfigHook oldAttrs.nativeBuildInputs;
    # Do not run `preBuild` when building `goModules`
    preBuild = null;
  };

  npmDeps = fetchNpmDeps {
    src = "${src}/web";
    hash = "sha256-RkyQ7uY7OIpBY7ep2L2Ilq5abY0f91g2uqigdS64sL0=";
  };

  vendorHash = "sha256-gqiK96FnfvRAzT0RUpYnT7HftZ1YV9jxbjstcKtGBho=";

  meta = {
    description = "Web application that lets you save the readable content of web pages you want to keep forever";
    mainProgram = "readeck";
    homepage = "https://readeck.org/";
    changelog = "https://codeberg.org/readeck/readeck/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ julienmalka ];
  };
}
