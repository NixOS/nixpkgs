{
  lib,
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
  version = "1.8.3";
  src = fetchFromGitHub {
    owner = "thomiceli";
    repo = "opengist";
    rev = "v${version}";
    hash = "sha256-Wpn9rqOUwbwi6pbPTnVzHb+ip3ay9WykEZDyHNdXYJU=";
  };

  frontend = buildNpmPackage {
    pname = "opengist-frontend";
    inherit version src;
    patches = [
      # fix lock file
      # https://github.com/thomiceli/opengist/pull/395
      (fetchpatch {
        url = "https://github.com/thomiceli/opengist/pull/395/commits/f77c624f73f18010c7e4360287d0a3c013c21c9d.patch";
        hash = "sha256-oCMt1HptH0jsi2cvv8wEP0+bpujx1jBxCjw0KMDGFfk=";
      })
    ];
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

    npmDepsHash = "sha256-fj2U8oRNfdIEnRkAOQQGiPyQFuWltLGkMzT2IQO60v0=";
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
    changelog = "https://github.com/thomiceli/opengist/blob/master/CHANGELOG.md";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "opengist";
  };
}
