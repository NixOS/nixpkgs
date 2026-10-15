{
  lib,
  fetchFromCodeberg,
  fetchNpmDeps,
  buildGoModule,
  nodejs_22,
  npmHooks,
  python3,
  templ,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "readeck";
  version = "0.23.4";

  src = fetchFromCodeberg {
    owner = "readeck";
    repo = "readeck";
    tag = finalAttrs.version;
    hash = "sha256-EUamQWH0ATc/6ofQHuFX3V2aXzU85nXcYQO+iZR9+Ys=";
  };

  nativeBuildInputs = [
    nodejs_22
    npmHooks.npmConfigHook
    (python3.withPackages (ps: with ps; [ babel ]))
    templ
  ];

  npmRoot = "web";

  env.NODE_PATH = "$npmDeps";

  postPatch = ''
    templ generate
  '';

  preBuild = ''
    make TEMPL=templ generate
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
    hash = "sha256-H8l9cpGYbLhbaU4PsU6KBhr8QZGh5sihE+3XdFwQRTg=";
  };

  vendorHash = "sha256-9BTNWePXmmKUMWM1evhgIMYipHX+pxozONZCbcCt8lo=";

  passthru = {
    tests = { inherit (nixosTests) readeck; };
    updateScript = nix-update-script { };
  };

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
