{
  lib,
  fetchFromGitHub,
  buildGoModule,
  ffmpeg,
  makeBinaryWrapper,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "seanime";
  version = "3.10.4";

  src = fetchFromGitHub {
    owner = "5rahim";
    repo = "seanime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3vJ3gtXa5RBpHCQikY+YEmyKRjThyzPyjTHuzOuUaS4=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    npmHooks.npmConfigHook
  ];

  env = {
    npmRoot = "seanime-web";
    npmDeps = fetchNpmDeps {
      src = "${finalAttrs.src}/seanime-web";
      hash = "sha256-fVZQADT1owzzqUjjamD8lzmEjLAJqYPatLOYvuBzSQQ=";
    };
  };

  patches = [ ./default-disable-update-check.patch ];

  preBuild = ''
    npm run build --prefix seanime-web
    cp -r seanime-web/out web

    # .github scripts redeclare main
    rm -rf .github
  '';

  vendorHash = "sha256-dCFDttoAqhXEErRtOS5Ti3CxyionxQQTglnOmsVRMto=";

  subPackages = [ "." ];

  doCheck = false; # broken in clean environments

  ldflags = [
    "-s"
    "-w"
  ];

  postFixup = ''
    # for transcoding
    wrapProgram "$out/bin/seanime" \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

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
