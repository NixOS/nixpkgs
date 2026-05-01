{
  lib,
  fetchFromCodeberg,
  fetchNpmDeps,
  buildGoModule,
  nodejs_22,
  npmHooks,
  python3,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "readeck";
  version = "0.22.2";

  src = fetchFromCodeberg {
    owner = "readeck";
    repo = "readeck";
    tag = finalAttrs.version;
    hash = "sha256-0arC5t7FlW5+AyGF9FuIPc+aeF+CMKIzO1vLJ7aisQE=";
  };

  nativeBuildInputs = [
    nodejs_22
    npmHooks.npmConfigHook
    (python3.withPackages (ps: with ps; [ babel ]))
  ];

  npmRoot = "web";

  env.NODE_PATH = "$npmDeps";

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
    "codeberg.org/readeck/readeck/configs.version=${finalAttrs.version}"
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
    src = "${finalAttrs.src}/web";
    hash = "sha256-80mh7fATUKf9G/JGsfHYHOLjr/je7g0uRdRGqBWapnY=";
  };

  vendorHash = "sha256-4cLv7eYNzj+YzrinbEg7tT+JkEen+C5ypg3NTQOB6FM=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web application that lets you save the readable content of web pages you want to keep forever";
    mainProgram = "readeck";
    homepage = "https://readeck.org/";
    changelog = "https://codeberg.org/readeck/readeck/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      julienmalka
      linsui
    ];
  };
})
