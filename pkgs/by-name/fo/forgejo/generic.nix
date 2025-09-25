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
  forgejo,
  git,
  gzip,
  lib,
  makeWrapper,
  nix-update-script,
  nixosTests,
  openssh,
  sqliteSupport ? true,
  xorg,
  runCommand,
  stdenv,
  fetchFromGitea,
  buildNpmPackage,
}:

let
  src = fetchFromGitea {
    domain = "codeberg.org";
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

  preCheck = ''
    # $HOME is required for ~/.ssh/authorized_keys and such
    export HOME="$TMPDIR/home"

    # expose and use the GO_TEST_PACKAGES var from the Makefile
    # instead of manually copying over the entire list:
    # https://codeberg.org/forgejo/forgejo/src/tag/v7.0.4/Makefile#L124
    echo -e 'show-backend-tests:\n\t@echo ''${GO_TEST_PACKAGES}' >> Makefile
    getGoDirs() {
      make show-backend-tests
    }
  '';

  checkFlags =
    let
      skippedTests = [
        "TestPassword" # requires network: api.pwnedpasswords.com
        "TestCaptcha" # requires network: hcaptcha.com
        "TestDNSUpdate" # requires network: release.forgejo.org
        "TestMigrateWhiteBlocklist" # requires network: gitlab.com (DNS)
        "TestURLAllowedSSH/Pushmirror_URL" # requires network git.gay (DNS)
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
            xorg.lndir
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
    maintainers = with lib.maintainers; [
      emilylange
      urandom
      bendlas
      adamcstephens
      marie
      pyrox0
      tebriel
    ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "forgejo";
  };
}
