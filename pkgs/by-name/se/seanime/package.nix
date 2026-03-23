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
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "5rahim";
    repo = "seanime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ejXWQPUROIzu6RlUJIaKaiJfPb59kupQDhqWU83EqP4=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  env = {
    npmRoot = "seanime-web";
    npmDeps = fetchNpmDeps {
      src = "${finalAttrs.src}/seanime-web";
      hash = "sha256-fWlK2h0RQF9GnEogXW3bwM01RCCDVij/9S2sn2BA3S4=";
    };
  };

  patches = [ ./default-disable-update-check.patch ];

  preBuild = ''
    npm run build --prefix seanime-web
    cp -r seanime-web/out web

    # .github scripts redeclare main
    rm -rf .github
  '';

  vendorHash = "sha256-TN9shH4B7XVDIa541+7MHTNQs1IKPRJW1dn8tmES5jg=";

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
