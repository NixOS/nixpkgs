{
  lib,
  stdenv,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  moreutils,
  jq,
  gitMinimal,
  writableTmpDirAsHomeHook,
  makeWrapper,
  nixosTests,
  formats,
}:

buildGoModule (finalAttrs: {
  pname = "opengist";

  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "thomiceli";
    repo = "opengist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BOqAmQsT8MtohE/1k2YaNZv8cmruWzLur+yyNs3ARcQ=";
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

    npmDepsHash = "sha256-hAG0vGjG+ejumjoslYs/UnYBImZDNsTQUDtssT0X/HI=";
  };

  vendorHash = "sha256-YU1OdYM9GzUGHypgIhWvJCvYEzlKsaKGN0NZRBfT8FY=";

  tags = [ "fs_embed" ];

  ldflags = [
    "-s"
    "-X github.com/thomiceli/opengist/internal/config.OpengistVersion=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  nativeCheckInputs = [
    gitMinimal
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

  postInstall = ''
    wrapProgram $out/bin/opengist \
      --prefix PATH : ${
        lib.makeBinPath [
          gitMinimal
        ]
      }
  '';

  passthru = {
    inherit (finalAttrs) frontend;
    updateScript = ./update.sh;
    tests = nixosTests.opengist-modular;
    services.default = {
      imports = [
        (lib.modules.importApply ./service.nix { inherit formats; })
      ];
      opengist.package = lib.mkDefault finalAttrs.finalPackage;
    };
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
