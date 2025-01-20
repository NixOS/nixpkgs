{
  lib,
  fetchFromGitea,
  buildGoModule,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  file-compose,
}:

buildGoModule rec {
  pname = "readeck";
  version = "0.17.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "readeck";
    repo = "readeck";
    rev = version;
    hash = "sha256-+GgjR1mxD93bFNaLeDuEefPlQEV9jNgFIo8jTAxphyo=";
  };

  npmDeps = fetchNpmDeps {
    src = "${src}/web";
    hash = "sha256-7fRSkXKAMEC7rFmSF50DM66SVhV68g93PMBjrtkd9/E=";
  };

  vendorHash = "sha256-O/ZrpT6wTtPwBDUCAmR0XHRgQmd46/MPvWNE0EvD3bg=";

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  npmRoot = "web";

  NODE_PATH = "$npmDeps";

  preBuild = ''
    make web-build
    ${lib.getExe file-compose} -format json docs/api/api.yaml docs/assets/api.json
    go run ./tools/docs docs/src docs/assets
  '';

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

  meta = {
    changelog = "https://codeberg.org/readeck/readeck/releases/tag/${version}";
    description = "Readeck is a simple web application that lets you save the precious readable content of web pages you like and want to keep forever";
    homepage = "https://codeberg.org/readeck/readeck";
    license = lib.licenses.agpl3Only;
    mainProgram = "readeck";
    maintainers = with lib.maintainers; [ ];
  };
}
