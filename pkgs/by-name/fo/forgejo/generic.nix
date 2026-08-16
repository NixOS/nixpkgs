{
  lts ? false,
  version,
  rev ? "refs/tags/v${version}",
  hash,
  npmDepsHash,
  vendorHash,
  nixUpdateExtraArgs ? [ ],
}:

{
  bash,
  brotli,
  buildGoModule,
  coreutils,
  forgejo,
  git,
  gzip,
  lib,
  makeWrapper,
  nix-update-script,
  nixosTests,
  openssh,
  sqliteSupport ? true,
  lndir,
  runCommand,
  stdenv,
  fetchFromCodeberg,
  buildNpmPackage,
  writableTmpDirAsHomeHook,
}:

let
  src = fetchFromCodeberg {
    owner = "forgejo";
    repo = "forgejo";
    inherit rev hash;
  };

  frontend = buildNpmPackage {
    pname = "forgejo-frontend";
    inherit src version npmDepsHash;

    buildPhase = ''
      ./node_modules/.bin/webpack
    '';

    # override npmInstallHook
    installPhase = ''
      mkdir $out
      cp -R ./public $out/
    '';
  };
in
buildGoModule rec {
  pname = "forgejo" + lib.optionalString lts "-lts";

  inherit
    version
    src
    vendorHash
    ;

  subPackages = [
    "."
    "contrib/environment-to-ini"
  ];

  outputs = [
    "out"
    "data"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  nativeCheckInputs = [
    git
    openssh
    writableTmpDirAsHomeHook
  ];

  patches = [
    ./static-root-path.patch
  ];
  postPatch = ''
    substituteInPlace modules/setting/server.go --subst-var data
  '';

  tags = lib.optionals sqliteSupport [
    "sqlite"
    "sqlite_unlock_notify"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X 'main.Tags=${lib.concatStringsSep " " tags}'"
  ];

  preConfigure = ''
    export ldflags+=" -X main.ForgejoVersion=$(GITEA_VERSION=${version} make show-version-api)"
  '';

  # expose and use the GO_TEST_PACKAGES var from the Makefile
  # instead of manually copying over the entire list:
  # https://codeberg.org/forgejo/forgejo/src/tag/v11.0.6/Makefile#L128
  # https://codeberg.org/forgejo/forgejo/src/tag/v13.0.0/Makefile#L290
  preCheck = ''
    echo -e 'show-backend-tests: | compute-go-test-packages\n\t@echo ''${GO_TEST_PACKAGES}' >> Makefile
    getGoDirs() {
      make show-backend-tests
    }

    # TestRunHookPrePostReceive (cmd/hook_test.go) needs .git to pass
    git init
  ''
  # Unlike NixOS, the Nix build sandbox has no /usr/bin/env and we
  # can't just create it, so Forgejo trying to execute git hooks
  # that have #!/usr/bin/env as shebang fails with:
  #
  #  To /build/repos44353414/user2/repo1.wiki.git
  #   ! [remote rejected] fda09356fb8b1da00546f764933f9dacda1b44ea -> master (pre-receive hook declined)
  #  error: failed to push some refs to '/build/repos44353414/user2/repo1.wiki.git'
  #   - remote: fatal: cannot exec '/build/appdata2719412950/home/hooks/pre-receive': No such file or directory
  #
  # We also can't just call patchShebangs because the hooks are
  # created just in time by the test suite. Patching the source of
  # the hooks after go build but before go test is oddly enough
  # the least invasive hack to have those tests pass.
  + lib.optionalString (lib.versionAtLeast version "16") ''
    substituteInPlace modules/git/hook_generate.go \
      --replace-fail "#!/usr/bin/env" "#!${lib.getExe' coreutils "env"}"
  '';

  checkFlags =
    let
      skippedTests = [
        "TestPassword" # requires network: api.pwnedpasswords.com
        "TestCaptcha" # requires network: hcaptcha.com
        "TestDNSUpdate" # requires network: release.forgejo.org
      ]
      ++ lib.optionals (lib.versionAtLeast version "16") [
        "TestMigrateRepository" # requires network: codeberg.org
      ]
      ++ [
        "TestMigrateWhiteBlocklist" # requires network: gitlab.com (DNS)
        "TestURLAllowedSSH/Pushmirror_URL" # requires network git.gay (DNS)
        "TestBleveDeleteIssue" # Known Flake-y https://github.com/NixOS/nixpkgs/issues/509878
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  preInstall = ''
    mv "$GOPATH/bin/forgejo.org" "$GOPATH/bin/forgejo"
  '';

  postInstall = ''
    mkdir $data
    cp -R ./{templates,options} ${frontend}/public $data
    mkdir -p $out
    cp -R ./options/locale $out/locale
    wrapProgram $out/bin/forgejo \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          git
          gzip
          openssh
        ]
      }
  '';

  # $data is not available in goModules.drv
  overrideModAttrs = (
    _: {
      postPatch = null;
    }
  );

  passthru = {
    # allow nix-update to handle npmDepsHash
    inherit (frontend) npmDeps;

    data-compressed =
      runCommand "forgejo-data-compressed"
        {
          nativeBuildInputs = [
            brotli
            lndir
          ];
        }
        ''
          mkdir $out
          lndir ${forgejo.data}/ $out/

          # Create static gzip and brotli files
          find -L $out -type f -regextype posix-extended -iregex '.*\.(css|html|js|svg|ttf|txt)' \
            -exec gzip --best --keep --force {} ';' \
            -exec brotli --best --keep --no-copy-stat {} ';'
        '';

    tests = if lts then nixosTests.forgejo-lts else nixosTests.forgejo;

    updateScript = nix-update-script {
      extraArgs = nixUpdateExtraArgs ++ [
        "--version-regex"
        "v(${lib.versions.major version}\\.[0-9.]+)"
      ];
    };
  };

  meta = {
    description = "Self-hosted lightweight software forge";
    homepage = "https://forgejo.org";
    changelog = "https://codeberg.org/forgejo/forgejo/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.forgejo ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "forgejo";
  };
}
