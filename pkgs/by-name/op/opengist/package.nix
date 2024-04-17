{ lib, buildGoModule, buildNpmPackage, fetchFromGitHub, moreutils, jq, git }:
let
  # finalAttrs when 🥺 (buildGoModule does not support them)
  # https://github.com/NixOS/nixpkgs/issues/273815
  version = "1.6.1";
  src = fetchFromGitHub {
    owner = "thomiceli";
    repo = "opengist";
    rev = "v${version}";
    hash = "sha256-rJ8oiH08kSSFNgPHKGo68Oi1i3L1SEJyHuzoxKMOZME=";
  };

  frontend = buildNpmPackage {
    pname = "opengist-frontend";
    inherit version src;

    nativeBuildInputs = [ moreutils jq ];

    # npm complains of "invalid package". shrug. we can give it a version.
    preBuild = ''
      jq '.version = "${version}"' package.json | sponge package.json
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

    npmDepsHash = "sha256-Sy321tIQOOrypk+EOGGixEzrPdhA9U8Hak+DOS+d00A=";
  };
in
buildGoModule {
  pname = "opengist";
  inherit version src;
  vendorHash = "sha256-IorqXJKzUTUL5zfKRipZaJtRlwVOmTwolJXFG/34Ais=";
  tags = [
    "fs_embed"
  ];

  # required for tests
  nativeCheckInputs = [
    git
  ];

  # required for tests to not try to write into $HOME and fail
  preCheck = ''
    export OG_OPENGIST_HOME=$(mktemp -d)
  '';

  postPatch = ''
    cp -R ${frontend}/public/{manifest.json,assets} public/
  '';

  passthru.frontend = frontend;

  meta = {
    description = "Self-hosted pastebin powered by Git";
    mainProgram = "opengist";
    homepage = "https://github.com/thomiceli/opengist";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lf- ];
    platforms = lib.platforms.unix;
  };
}
