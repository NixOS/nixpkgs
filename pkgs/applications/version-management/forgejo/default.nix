{ bash
, brotli
, buildGoModule
, forgejo
, git
, gzip
, lib
, makeWrapper
<<<<<<< HEAD
, nix-update-script
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
}:

let
  frontend = buildNpmPackage {
    pname = "forgejo-frontend";
    inherit (forgejo) src version;

    npmDepsHash = "sha256-YZzVw+WWqTmJafqnZ5vrzb7P6V4DTMNQwW1/+wvZEM8=";
=======
, writeShellApplication
}:

let
  frontend = buildNpmPackage rec {
    pname = "forgejo-frontend";
    inherit (forgejo) src version;

    npmDepsHash = "sha256-dB/uBuS0kgaTwsPYnqklT450ejLHcPAqBdDs3JT8Uxg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
  version = "1.20.4-0";
=======
  version = "1.19.3-0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "forgejo";
    repo = "forgejo";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-guKU3VG1Wyhr5p6w0asL/CopQ5b7HiNi26Tw8WCEpwE=";
  };

  vendorHash = "sha256-dgtZjsLBwblhdge3BvdbK/mN/TeZKps9K5dJbqomtjo=";
=======
    hash = "sha256-0T26EsU5lJ+Rxy/jSDn8nTk5IdHO8oK3LvN7tPArPgs=";
  };

  vendorHash = "sha256-bnLcHmwOh/fw6ecgsndX2BmVf11hJWllE+f2J8YSzec=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  outputs = [ "out" "data" ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optional pamSupport pam;

  patches = [
    ./../gitea/static-root-path.patch
  ];

  postPatch = ''
    substituteInPlace modules/setting/setting.go --subst-var data
  '';

  tags = lib.optional pamSupport "pam"
    ++ lib.optionals sqliteSupport [ "sqlite" "sqlite_unlock_notify" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X 'main.Tags=${lib.concatStringsSep " " tags}'"
  ];

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

<<<<<<< HEAD
  # $data is not available in goModules.drv and preBuild isn't needed
=======
  # $data is not available in go-modules.drv and preBuild isn't needed
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  overrideModAttrs = (_: {
    postPatch = null;
    preBuild = null;
  });

  passthru = {
<<<<<<< HEAD
    # allow nix-update to handle npmDepsHash
    inherit (frontend) npmDeps;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A self-hosted lightweight software forge";
    homepage = "https://forgejo.org";
    changelog = "https://codeberg.org/forgejo/forgejo/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emilylange urandom bendlas adamcstephens ];
=======
  };

  meta = with lib; {
    description = "A self-hosted lightweight software forge";
    homepage = "https://forgejo.org";
    changelog = "https://codeberg.org/forgejo/forgejo/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ indeednotjames urandom ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    broken = stdenv.isDarwin;
    mainProgram = "gitea";
  };
}
