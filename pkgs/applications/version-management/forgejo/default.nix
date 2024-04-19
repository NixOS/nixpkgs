{ bash
, brotli
, buildGoModule
, forgejo
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

    npmDepsHash = "sha256-YZzVw+WWqTmJafqnZ5vrzb7P6V4DTMNQwW1/+wvZEM8=";

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
  version = "1.20.6-1-unstable-2024-04-18";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "forgejo";
    repo = "forgejo";
    # latest commit from 1.20.x branch (2024-04-18) with 1.21.6-0's and
    # 1.21.11-0's security fixes backported.
    # coordinated with upstream in #forgejo-development:matrix.org :)
    # https://codeberg.org/forgejo/forgejo/src/branch/v1.20/forgejo
    # https://codeberg.org/forgejo/forgejo/pulls/2443
    # https://codeberg.org/forgejo/forgejo/commit/2fe5f6f73283c2f6935ded62440a1f15ded12dcd
    # https://codeberg.org/forgejo/forgejo/pulls/3319
    # https://codeberg.org/forgejo/forgejo/commit/0c4a307ee2aeaaf464ed74521b1fdb12114fde60
    rev = "0c4a307ee2aeaaf464ed74521b1fdb12114fde60";
    hash = "sha256-S2aRSXJybrjgpN16/1vbV1CUoMc1IvUGBO2DXB1CTYE=";
    # Forgejo has multiple different version strings that need to be provided
    # via ldflags.  main.ForgejoVersion for example is a combination of a
    # hardcoded gitea compatibility version string (in the Makefile) and
    # git describe and is easiest to get by invoking the Makefile.
    # So we do that, store it the src FOD to then extend the ldflags array
    # in preConfigure.
    # The `echo -e >> Makefile` is temporary and already part of the next
    # major release.  Furthermore, the ldflags will change next major release
    # and need to be updated accordingly.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      echo -e 'show-version-full:\n\t@echo ''${FORGEJO_VERSION}' >> Makefile
      make show-version-full > FULL_VERSION
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-ao2CY6LmiDQIgv/i8okWt+xGa+clHzbCEHYFUrlwox0=";

  subPackages = [ "." ];

  outputs = [ "out" "data" ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optional pamSupport pam;

  patches = [
    ./static-root-path.patch
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
    export ldflags+=" -X code.gitea.io/gitea/routers/api/forgejo/v1.ForgejoVersion=$(cat FULL_VERSION) -X main.ForgejoVersion=$(cat FULL_VERSION)"
  '';

  preBuild = ''
    go run build/merge-forgejo-locales.go
  '';

  postInstall = ''
    mkdir $data
    cp -R ./{templates,options} ${frontend}/public $data
    mkdir -p $out
    cp -R ./options/locale $out/locale
    wrapProgram $out/bin/gitea \
      --prefix PATH : ${lib.makeBinPath [ bash git gzip openssh ]}
  '';

  # $data is not available in goModules.drv and preBuild isn't needed
  overrideModAttrs = (_: {
    postPatch = null;
    preBuild = null;
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
    description = "A self-hosted lightweight software forge";
    homepage = "https://forgejo.org";
    changelog = "https://codeberg.org/forgejo/forgejo/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emilylange urandom bendlas adamcstephens ];
    broken = stdenv.isDarwin;
    mainProgram = "gitea";
  };
}
