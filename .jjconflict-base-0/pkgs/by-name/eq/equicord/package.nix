{
  fetchFromGitHub,
  git,
  lib,
  nodejs,
  pnpm_9,
  stdenv,
  buildWebExtension ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "equicord";
  version = "1.10.8"; # from package.json

  src = fetchFromGitHub {
    owner = "Equicord";
    repo = "Equicord";
    rev = "935a5eaf6e5894294ec45ec540e9ecb07e850de0";
    hash = "sha256-dfOzASBP0dEArJXuddLfPLZ7IcsEfKll+ju1jcHarNk=";
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
    EQUICORD_HASH = "${finalAttrs.src.rev}";
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
