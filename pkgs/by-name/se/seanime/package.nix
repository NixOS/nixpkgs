{
  lib,
  fetchFromGitHub,
  buildGoModule,
  ffmpeg,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "seanime";
  version = "3.8.2";

  src = fetchFromGitHub {
    owner = "5rahim";
    repo = "seanime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7wOmvOrs4/YiIjOGdp6pleUcUjNaXhZFvtwBTSn5BQI=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  env = {
    npmRoot = "seanime-web";
    npmDeps = fetchNpmDeps {
      src = "${finalAttrs.src}/seanime-web";
      hash = "sha256-LtRiwmrWSu4Zc0+/AywEEGpcxElIrp0A+x+8jWMfKig=";
    };
  };

  patches = [ ./default-disable-update-check.patch ];

  preBuild = ''
    npm run build --prefix seanime-web
    cp -r seanime-web/out web

    # .github scripts redeclare main
    rm -rf .github
  '';

  vendorHash = "sha256-BPOLDqa9qt/nISJ6Ja6ZSDGf8oXwKgZ6sbMee6hFLfs=";

  subPackages = [ "." ];

  doCheck = false; # broken in clean environments

  ldflags = [
    "-s"
    "-w"
  ];

  # for transcoding
  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        ffmpeg
      ]
    }"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source media server for anime and manga";
    homepage = "https://seanime.app";
    changelog = "https://github.com/5rahim/seanime/blob/main/CHANGELOG.md";
    mainProgram = "seanime";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ thegu5 ];
  };
})
