{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "oh-my-posh";
  version = "29.37.0";

  src = fetchFromGitHub {
    owner = "jandedobbeleer";
    repo = "oh-my-posh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ydUheYGG/7G1om/h7HGxA4uFW4/KYy0E/9OONT+P+os=";
  };

  vendorHash = "sha256-2BlJ6un86mqPAH9DsugZV96bnHN8fByypaqYsrTwaPk=";

  sourceRoot = "${finalAttrs.src.name}/src";

  ldflags = [
    "-s"
    "-X github.com/jandedobbeleer/oh-my-posh/src/build.Version=${finalAttrs.version}"
    "-X github.com/jandedobbeleer/oh-my-posh/src/build.Date=1970-01-01T00:00:00Z"
  ];

  tags = [
    "netgo"
    "osusergo"
    "static_build"
  ];

  postPatch = ''
    # these tests requires internet access
    rm cli/image/image_test.go config/migrate_glyphs_test.go cli/upgrade/notice_test.go segments/upgrade_test.go
  '';

  postInstall = ''
    mv $out/bin/{src,oh-my-posh}
    mkdir -p $out/share/oh-my-posh
    cp -r $src/themes $out/share/oh-my-posh/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Prompt theme engine for any shell";
    mainProgram = "oh-my-posh";
    homepage = "https://ohmyposh.dev";
    changelog = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lucperkins
      olillin
    ];
  };
})
