{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitea,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

let
  simpleCss = fetchFromGitHub {
    owner = "kevquirk";
    repo = "simple.css";
    rev = "ba4af949057d489331759e0118de596222e0f5b7";
    hash = "sha256-rihjNW1gf0k7DI8x+vaFUR4ehI3gXDV9zWV3DGSg4y8=";
  };
in

buildGoModule (finalAttrs: {
  pname = "searchix";
  version = "0.4.5";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "alinnow";
    repo = "searchix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2pffyKBX+ICYEN+42gwN2byjw+T9H4esi2+oTqs52GE=";
  };

  vendorHash = "sha256-yfcQgy4cQFRvtsyLHLojnJaWhle1ZR3unmaFQj8ljuw=";

  subPackages = [ "cmd/searchix-web" ];

  tags = [ "embed" ];

  ldflags = [
    "-s"
    "-X=alin.ovh/searchix/internal/config.Version=${finalAttrs.version}"
  ];

  preBuild = ''
    rm -f frontend/static/base.css
    cp ${simpleCss}/simple.css frontend/static/base.css
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    $out/bin/searchix-web generate-error-page --outdir $out/share/searchix/
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Search tool for options and packages in the NixOS ecosystem";
    homepage = "https://searchix.ovh/";
    downloadPage = "https://codeberg.org/alinnow/searchix";
    changelog = "https://codeberg.org/alinnow/searchix/src/tag/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      airone01
      BatteredBunny
    ];
    mainProgram = "searchix-web";
  };
})
