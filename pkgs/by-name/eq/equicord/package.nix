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
  version = "1.10.8";

  src = fetchFromGitHub {
    owner = "Equicord";
    repo = "Equicord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kbK9tnu0G/nLy4A06xvd2yvlc6UhQfKiC6I9qmJeIwc=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-HAKNc8ZyIGEkrNbqQSycR1wePPOisF8nc4/E+KmKyYU=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The other cutest Discord client mod";
    homepage = "https://github.com/Equicord/Equicord";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [
      lib.maintainers.NotAShelf
    ];
  };
})
