{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  nixosTests,
  stdenv,
  npmHooks,
  nodejs,
  esbuild,
  brotli,
  zstd,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "anubis";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "TecharoHQ";
    repo = "anubis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CZpQT3Uu0TNC4ra9f+OZWfovOJ+xFyumomETc10fOGA=";
  };

  vendorHash = "sha256-9CMD8Rn4q8b+hyrph+BqqS32ijZyJRNsop6ML7z5Zuk=";

  npmDeps = fetchNpmDeps {
    name = "anubis-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-wozZu00ir7V3mO6BLBamaxhI5fTdWgXQK+xGvr3T1gU=";
  };

  nativeBuildInputs = [
    esbuild
    brotli
    zstd

    nodejs
    npmHooks.npmConfigHook
  ];

  subPackages = [ "cmd/anubis" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/TecharoHQ/anubis.Version=v${finalAttrs.version}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ "-extldflags=-static" ];

  prePatch = ''
    # we must forcefully disable the hook when creating the go vendor archive
    if [[ $name =~ go-modules ]]; then
      npmConfigHook() { true; }
    fi
  '';

  postPatch = ''
    patchShebangs ./web/build.sh ./lib/challenge/preact/build.sh
  '';

  preBuild = ''
    # do not run when creating go vendor archive
    if [[ ! $name =~ go-modules ]]; then
      # https://github.com/TecharoHQ/anubis/blob/main/xess/build.sh
      npx postcss ./xess/xess.css -o xess/xess.min.css
      go generate ./...
      ./web/build.sh
    fi
  '';

  preCheck = ''
    export DONT_USE_NETWORK=1
  '';

  passthru = {
    tests = { inherit (nixosTests) anubis; };
    updateScript = nix-update-script { extraArgs = [ "--version-regex=^v(\\d+\\.\\d+\\.\\d+)$" ]; };
  };

  meta = {
    description = "Weighs the soul of incoming HTTP requests using proof-of-work to stop AI crawlers";
    homepage = "https://anubis.techaro.lol/";
    downloadPage = "https://github.com/TecharoHQ/anubis";
    changelog = "https://github.com/TecharoHQ/anubis/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      knightpp
      soopyc
      ryand56
      defelo
    ];
    mainProgram = "anubis";
  };
})
