{
  fetchFromGitHub,
  git,
  lib,
  nodejs,
  pnpm_10,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  stdenv,
  nix-update-script,
  discord,
  discord-ptb,
  discord-canary,
  discord-development,
  buildWebExtension ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "equicord";
  # Upstream discourages inferring the package version from the package.json found in
  # the Equicord repository. Dates as tags (and automatic releases) were the compromise
  # we came to with upstream. Please do not change the version schema (e.g., to semver)
  # unless upstream changes the tag schema from dates.
<<<<<<< HEAD
  version = "2025-12-25";
=======
  version = "2025-11-16";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Equicord";
    repo = "Equicord";
    tag = "${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-ce5n7E+eJLPnj/dUnaaDi4R8kKO4+iOcQgdtOin4NcM=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 1;
    hash = "sha256-iBCA4G1E1Yw/d94pQzcbBGJYeIIgZI+Gw87/x4ogoyg=";
=======
    hash = "sha256-12P62UAt9eiQoGCXQGYQx0cPmankniltGqPTsys9Ves=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-gl/4+AN3+YOl3uCYholPU8jo0IayazlY987fwhtHCuk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    git
    nodejs
<<<<<<< HEAD
    pnpmConfigHook
    pnpm_10
=======
    pnpm_10.configHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  env = {
    EQUICORD_REMOTE = "${finalAttrs.src.owner}/${finalAttrs.src.repo}";
    EQUICORD_HASH = "${finalAttrs.src.tag}";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run ${if buildWebExtension then "buildWeb" else "build"} \
      -- --standalone --disable-updater

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist/${lib.optionalString buildWebExtension "chromium-unpacked/"} $out

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^(\\d{4}-\\d{2}-\\d{2})$"
      ];
    };
    tests = lib.genAttrs' [ discord discord-ptb discord-canary discord-development ] (
      p: lib.nameValuePair p.pname p.tests.withEquicord
    );
  };

  meta = {
    description = "Other cutest Discord client mod";
    homepage = "https://github.com/Equicord/Equicord";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = [
      lib.maintainers.NotAShelf
    ];
  };
})
