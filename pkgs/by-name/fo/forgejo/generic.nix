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
  fetchpatch,
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
  writableTmpDirAsHomeHook,
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
    writableTmpDirAsHomeHook
  ];

  patches = [
    ./static-root-path.patch
  ]
  ++ lib.optionals lts [
    (fetchpatch {
      # fix for go 1.25.2 stricter ipv6 parsing, remove for LTS > 11.0.6
      name = "fix-test-ipv6-go125.patch";
      url = "https://codeberg.org/forgejo/forgejo/commit/0d9a8e3fa2cf9228290ed1a9a5767e6ba204edd7.patch";
      hash = "sha256-AM4/kgCXSU5Bj8aOObm6qyeL1SEpeFhmlT42lMJ2o08=";
    })
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
    echo -e 'show-backend-tests:${lib.optionalString (lib.versionAtLeast version "13") " | compute-go-test-packages"}\n\t@echo ''${GO_TEST_PACKAGES}' >> Makefile
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
