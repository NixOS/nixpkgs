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
  version = "1.11.9"; # from package.json

  src = fetchFromGitHub {
    owner = "Equicord";
    repo = "Equicord";
    # Upstream does not consistently tag their releases. We use a hash
    # even if they have releases, because chances are the "latest" tag
    # will be outdated regardless. I tried asking them to do it, but it
    # appears that there is no interest. Please manually update the rev
    # and pnpmDeps hash each time a version has been bumped in upstream
    # package.json, to at least have a resemblance of stable tagging.
    rev = "cf7dc5522d785a14878662d28153a5b90507bab1";
    hash = "sha256-+IcyklSfSha/MFbVH/TbbxKW/4rUeFcJnlUm8jNavIM=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-fjfzBy1Z7AUKA53yjjCQ6yasHc5QMaOBtXtXA5fNK5s=";
  };

  nativeBuildInputs = [
    git
    nodejs
    pnpm_9.configHook
  ];

  env = {
    EQUICORD_REMOTE = "${finalAttrs.src.owner}/${finalAttrs.src.repo}";
    EQUICORD_HASH = "${finalAttrs.version}";
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
