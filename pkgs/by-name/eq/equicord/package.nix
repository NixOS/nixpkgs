{
  fetchFromGitHub,
  git,
  lib,
  nodejs,
  pnpm_10,
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
  version = "2025-09-12";

  src = fetchFromGitHub {
    owner = "Equicord";
    repo = "Equicord";
    tag = "${finalAttrs.version}";
    hash = "sha256-915HW2cGGKtbRGghHP/Em0Wyeit6d1oSUmaZLQOH/Lc=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-xVnryPA7+gnRvpMzuFJl4YeEPOky2+iOu76V3Rf6bow=";
  };

  nativeBuildInputs = [
    git
    nodejs
    pnpm_10.configHook
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
      "^(\\d{4}-\\d{2}-\\d{2})$"
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
