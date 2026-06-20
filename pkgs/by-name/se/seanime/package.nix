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
  version = "3.8.6";

  src = fetchFromGitHub {
    owner = "5rahim";
    repo = "seanime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k3bUytIJPyCXjo6/6JbOg7WB6b26Uqj7HKrAzjmWmPU=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  env = {
    npmRoot = "seanime-web";
    npmDeps = fetchNpmDeps {
      src = "${finalAttrs.src}/seanime-web";
      hash = "sha256-47SRdvaTlGyuqdImeZaVGEyFWkkuECJzaQpeujybNgA=";
    };
  };

  patches = [ ./default-disable-update-check.patch ];

  preBuild = ''
    npm run build --prefix seanime-web
    cp -r seanime-web/out web

    # .github scripts redeclare main
    rm -rf .github
  '';

  vendorHash = "sha256-cLUD6UvGQiOwuLlfScDPCvwmf3L66DIsBF/Gc1aWgrY=";

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
