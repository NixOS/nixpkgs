{
  fetchFromGitHub,
  git,
  lib,
  nodejs,
  pnpm_9,
  stdenv,
  nix-update-script,
  buildWebExtension ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "equicord";
  # Upstream discourages inferring the package version from the package.json found in
  # the Equicord repository. Dates as tags (and automatic releases) were the compromise
  # we came to with upstream. Please do not change the version schema (e.g., to semver)
  # unless upstream changes the tag schema from dates.
  version = "2025-04-17";

  src = fetchFromGitHub {
    owner = "Equicord";
    repo = "Equicord";
    tag = "${finalAttrs.version}";
    hash = "sha256-pAuNqPrQBeL2qPIoIvyBl1PrUBz81TrBd5RT15Iuuus=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-fjfzBy1Z7AUKA53yjjCQ6yasHc5QMaOBtXtXA5fNK5s=";
  };

  nativeBuildInputs = [
    git
    nodejs
    pnpm_9.configHook
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^\d{4}-\d{2}-\d{2}$"
    ];
  };

  meta = {
    description = "Other cutest Discord client mod";
    homepage = "https://github.com/Equicord/Equicord";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [
      lib.maintainers.NotAShelf
    ];
  };
})
