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
  version = "1.11.4";

  src = fetchFromGitHub {
    owner = "Equicord";
    repo = "Equicord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BjAp+bubpG9tTo8y5LWcTCnpLbiyuY1Q6ZnprgeKoZg=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-4uCo/pQ4f8k/7DNpCPDAeqfroZ9icFiTwapwS10uWkE=";
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
