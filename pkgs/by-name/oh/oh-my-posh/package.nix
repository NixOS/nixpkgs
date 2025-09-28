{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "oh-my-posh";
  version = "26.26.0";

  src = fetchFromGitHub {
    owner = "jandedobbeleer";
    repo = "oh-my-posh";
    tag = "v${version}";
    hash = "sha256-nxrKu6EZY09AgQ5WSMnHKGH7wHF5TytRf6d4ORqul/o=";
  };

  vendorHash = "sha256-oeywDDWj0bSE0O0nQT2CfhFtiLp5Qwm/9tV4uSv2/MA=";

  sourceRoot = "${src.name}/src";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/jandedobbeleer/oh-my-posh/src/build.Version=${version}"
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
    changelog = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lucperkins
      urandom
    ];
  };
}
