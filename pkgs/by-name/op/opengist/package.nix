{
  lib,
  stdenv,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  moreutils,
  jq,
  git,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "opengist";

  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "thomiceli";
    repo = "opengist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jMB6TudICAjX0DGw62qP8X39q3OOT2Bvg70LJbFWqkE=";
  };

  frontend = buildNpmPackage {
    pname = "opengist-frontend";
    inherit (finalAttrs) version src;

    # npm complains of "invalid package". shrug. we can give it a version.
    postPatch = ''
      ${lib.getExe jq} '.version = "${finalAttrs.version}"' package.json | ${lib.getExe' moreutils "sponge"} package.json
    '';

    installPhase = ''
      mkdir -p $out
      cp -R public $out
    '';

    npmDepsHash = "sha256-Ci25S0kgT5C46xTzNTs0kn8QEvYqJuj/yU33Ymfci68=";
  };

  vendorHash = "sha256-MRY677UiZg7j5HTFejvuzIJwEMczbhi6sIbGYjRnWeM=";

  tags = [ "fs_embed" ];

  ldflags = [
    "-s"
    "-X github.com/thomiceli/opengist/internal/config.OpengistVersion=v${finalAttrs.version}"
  ];

  nativeCheckInputs = [
    git
    writableTmpDirAsHomeHook
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  checkPhase = ''
    runHook preCheck

    make test

    runHook postCheck
  '';

  postPatch = ''
    mkdir -p public/.vite
    cp ${finalAttrs.frontend}/public/.vite/manifest.json public/.vite/manifest.json
    cp -R ${finalAttrs.frontend}/public/assets public/
  '';

  passthru = {
    inherit (finalAttrs) frontend;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Self-hosted pastebin powered by Git";
    homepage = "https://github.com/thomiceli/opengist";
    license = lib.licenses.agpl3Only;
    changelog = "https://github.com/thomiceli/opengist/blob/v${finalAttrs.version}/CHANGELOG.md";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "opengist";
  };
})
