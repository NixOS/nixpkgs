{ bash
, brotli
, buildGoModule
, forgejo
, fetchpatch
, git
, gzip
, lib
, makeWrapper
, nix-update-script
, nixosTests
, openssh
, pam
, pamSupport ? true
, sqliteSupport ? true
, xorg
, runCommand
, stdenv
, fetchFromGitea
, buildNpmPackage
}:

let
  frontend = buildNpmPackage {
    pname = "forgejo-frontend";
    inherit (forgejo) src version;

    npmDepsHash = "sha256-Nu9aOjJpEAuCWWnJfZXy/GayiUDiyc3hOu6Bx7GxfxA=";

    patches = [
      ./package-json-npm-build-frontend.patch
    ];

    # override npmInstallHook
    installPhase = ''
      mkdir $out
      cp -R ./public $out/
    '';
  };
in
buildGoModule rec {
  pname = "forgejo";
  version = "7.0.4";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "forgejo";
    repo = "forgejo";
    rev = "v${version}";
    hash = "sha256-WtJJdqPbx5k9U+u3ZpI3q/dm3eidxdkFgc8IskaJg88=";
  };

  vendorHash = "sha256-TYVWou9fIVL4od2o1uOb/MRBpf2lIg/9Tem9w+ihYzU=";

  subPackages = [ "." "contrib/environment-to-ini" ];

  outputs = [ "out" "data" ];

  nativeBuildInputs = [
    makeWrapper
    git # checkPhase
    openssh # checkPhase
  ];
  buildInputs = lib.optional pamSupport pam;

  patches = [
    ./static-root-path.patch
    # Fix TestAddRecursiveExclude go test.
    # This will be part of the upcoming v7.0.5 release at which point this needs to be removed again.
    (fetchpatch {
      url = "https://codeberg.org/forgejo/forgejo/commit/f01dc4b271f54201e60a7c795d784813eac3f7ce.patch";
      sha256  = "sha256-1lPLVHBad+Fmk+6EFXKuMnmDUl5BkEYJuMkTPfdrCgU=";
    })
  ];

  postPatch = ''
    substituteInPlace modules/setting/server.go --subst-var data
  '';

  tags = lib.optional pamSupport "pam"
    ++ lib.optionals sqliteSupport [ "sqlite" "sqlite_unlock_notify" ];

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
        "Test_SSHParsePublicKey/dsa-1024/SSHKeygen" # dsa-1024 is deprecated in openssh and requires opting-in at compile time
        "Test_calcFingerprint/dsa-1024/SSHKeygen" # dsa-1024 is deprecated in openssh and requires opting-in at compile time
        "TestPamAuth" # we don't have PAM set up in the build sandbox
        "TestPassword" # requires network: api.pwnedpasswords.com
        "TestCaptcha" # requires network: hcaptcha.com
        "TestDNSUpdate" # requires network: release.forgejo.org
        "TestMigrateWhiteBlocklist" # requires network: gitlab.com (DNS)
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    mkdir $data
    cp -R ./{templates,options} ${frontend}/public $data
    mkdir -p $out
    cp -R ./options/locale $out/locale
    wrapProgram $out/bin/gitea \
      --prefix PATH : ${lib.makeBinPath [ bash git gzip openssh ]}
  '';

  # $data is not available in goModules.drv
  overrideModAttrs = (_: {
    postPatch = null;
  });

  passthru = {
    # allow nix-update to handle npmDepsHash
    inherit (frontend) npmDeps;

    data-compressed = runCommand "forgejo-data-compressed" {
      nativeBuildInputs = [ brotli xorg.lndir ];
    } ''
      mkdir $out
      lndir ${forgejo.data}/ $out/

      # Create static gzip and brotli files
      find -L $out -type f -regextype posix-extended -iregex '.*\.(css|html|js|svg|ttf|txt)' \
        -exec gzip --best --keep --force {} ';' \
        -exec brotli --best --keep --no-copy-stat {} ';'
    '';

    tests = nixosTests.forgejo;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Self-hosted lightweight software forge";
    homepage = "https://forgejo.org";
    changelog = "https://codeberg.org/forgejo/forgejo/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emilylange urandom bendlas adamcstephens ];
    broken = stdenv.isDarwin;
    mainProgram = "gitea";
  };
}
