{
  lib,
  stdenv,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch,
  moreutils,
  jq,
  git,
}:
let
  # finalAttrs when 🥺 (buildGoModule does not support them)
  # https://github.com/NixOS/nixpkgs/issues/273815
  version = "1.8.4";
  src = fetchFromGitHub {
    owner = "thomiceli";
    repo = "opengist";
    tag = "v${version}";
    hash = "sha256-vpl3ztLHeVZndAwDgobfiI+3Xu3CFU38qgXy83p06As=";
  };

  frontend = buildNpmPackage {
    pname = "opengist-frontend";
    inherit version src;
    # npm complains of "invalid package". shrug. we can give it a version.
    postPatch = ''
      ${lib.getExe jq} '.version = "${version}"' package.json | ${lib.getExe' moreutils "sponge"} package.json
    '';

    # copy pasta from the Makefile upstream, seems to be a workaround of sass
    # issues, unsure why it is not done in vite:
    # https://github.com/thomiceli/opengist/blob/05eccfa8e728335514a40476cd8116cfd1ca61dd/Makefile#L16-L19
    postBuild = ''
      EMBED=1 npx postcss 'public/assets/embed-*.css' -c public/postcss.config.js --replace
    '';

    installPhase = ''
      mkdir -p $out
      cp -R public $out
    '';

    npmDepsHash = "sha256-l09TPGBGhWcsl3x14ovilDd1zZWv4XzFCAmAfapKtAE=";
  };
in
buildGoModule {
  pname = "opengist";
  inherit version src;
  vendorHash = "sha256-mLFjRL4spAWuPLVOtt88KH+p2g9lGCYzaHokVxdrLOw=";
  tags = [ "fs_embed" ];
  ldflags = [
    "-s"
    "-X github.com/thomiceli/opengist/internal/config.OpengistVersion=v${version}"
  ];

  # required for tests
  nativeCheckInputs = [
    git
  ];

  # required for tests to not try to write into $HOME and fail
  preCheck = ''
    export OG_OPENGIST_HOME=$(mktemp -d)
  '';

  doCheck = !stdenv.hostPlatform.isDarwin;

  checkPhase = ''
    runHook preCheck
    make test
    runHook postCheck
  '';

  postPatch = ''
    cp -R ${frontend}/public/{manifest.json,assets} public/
  '';

  passthru = {
    inherit frontend;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Self-hosted pastebin powered by Git";
    homepage = "https://github.com/thomiceli/opengist";
    license = lib.licenses.agpl3Only;
    changelog = "https://github.com/thomiceli/opengist/blob/${src.tag}/CHANGELOG.md";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "opengist";
  };
}
