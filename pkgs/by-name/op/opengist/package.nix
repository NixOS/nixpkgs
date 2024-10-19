{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  moreutils,
  npm-lockfile-fix,
  jq,
  git,
}:
let
  # finalAttrs when 🥺 (buildGoModule does not support them)
  # https://github.com/NixOS/nixpkgs/issues/273815
  version = "1.7.5";
  src = fetchFromGitHub {
    owner = "thomiceli";
    repo = "opengist";
    rev = "v${version}";
    hash = "sha256-mZ4j9UWdKa3nygcRO5ceyONetkks3ZGWxvzD34eOXew=";

    # follow https://github.com/thomiceli/opengist/pull/350 and remove here
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  frontend = buildNpmPackage {
    pname = "opengist-frontend";
    inherit version src;

    nativeBuildInputs = [
      moreutils
      jq
    ];

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

    npmDepsHash = "sha256-cITkgRvWOml6uH77WkiNgFedEuPNze63Gntet09uS5w=";
  };
in
buildGoModule {
  pname = "opengist";
  inherit version src;
  vendorHash = "sha256-6PpS/dsonc/akBn8NwUIVFNe2FjynAhF1TYIYT9K/ws=";
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

  postPatch = ''
    cp -R ${frontend}/public/{manifest.json,assets} public/
  '';

  passthru.frontend = frontend;

  meta = {
    description = "Self-hosted pastebin powered by Git";
    homepage = "https://github.com/thomiceli/opengist";
    license = lib.licenses.agpl3Only;
    changelog = "https://github.com/thomiceli/opengist/blob/master/CHANGELOG.md";
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "opengist";
  };
}
