{
  lib,
  # Required version by go.mod. buildGoModule is at 125 at time of writing.
  buildGo126Module,
  fetchFromGitHub,
  nix-update-script,
}:
buildGo126Module (finalAttrs: {
  pname = "oh-my-posh";
  version = "29.9.0";

  src = fetchFromGitHub {
    owner = "jandedobbeleer";
    repo = "oh-my-posh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F80vnUm7/F16ucQ0UqZPjSmwR2c1uo5boNqlWQj2H3g=";
  };

  vendorHash = "sha256-EIaM2AbTuNwkNCWyBaRxB7ZTvHzSVZ8c9+N7KAUU/xU=";

  sourceRoot = "${finalAttrs.src.name}/src";

  ldflags = [
    "-s"
    "-w"
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
