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
  version = "3.10.1";

  src = fetchFromGitHub {
    owner = "5rahim";
    repo = "seanime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4BXb+9eTzH23pNyatFyhbfmt2tCqEF8K+iLlwXCxAeQ=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  env = {
    npmRoot = "seanime-web";
    npmDeps = fetchNpmDeps {
      src = "${finalAttrs.src}/seanime-web";
      hash = "sha256-4w4SYBt8bkFtRKnoxOWEFAcNT+Aa8/ALKgGza9LBZ5Q=";
    };
  };

  patches = [ ./default-disable-update-check.patch ];

  preBuild = ''
    npm run build --prefix seanime-web
    cp -r seanime-web/out web

    # .github scripts redeclare main
    rm -rf .github
  '';

  vendorHash = "sha256-eTKLiwyB3bUIUlwLck8NG6oRdYaJioNs4AiSSPjADyg=";

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
