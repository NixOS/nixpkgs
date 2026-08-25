{
  fetchFromGitHub,
  git,
  lib,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
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
  version = "2026-08-25";

  src = fetchFromGitHub {
    owner = "Equicord";
    repo = "Equicord";
    tag = finalAttrs.version;
    hash = "sha256-d15msuvzITPE9tzuZaJoWFRue77vFSAsaFLSV8e2PRM=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-rx8z6PAlAPaZbkmg+3Vvq8OXR/yy5ZP0PmAk97ZDOSQ=";
  };

  nativeBuildInputs = [
    git
    nodejs
    pnpmConfigHook
    pnpm_10
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
