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

    npmDepsHash = "sha256-uMPy4cqMDNZTpF+pk7YibXEJO1zxVfwlCeFzGgJBiU0=";

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
  version = "1.21.11-0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "forgejo";
    repo = "forgejo";
    rev = "v${version}";
    hash = "sha256-Cp+dN4nTIboin42NJR/YUkVXbBC7uufH8EE7NgIVFzY=";
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

  vendorHash = "sha256-OuWNF+muWM6xqwkFxLIUsn/huqXj2VKg8BN9+JHVw58=";

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
