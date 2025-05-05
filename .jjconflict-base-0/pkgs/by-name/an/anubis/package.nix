{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  stdenv,

  esbuild,
  brotli,
  zstd,
}:
let
  pname = "anubis";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "TecharoHQ";
    repo = "anubis";
    tag = "v${version}";
    hash = "sha256-8b2rVVuxhsY0+5IZvzMm7ki3HGbJAnUUoAqpD1PuqZ4=";
  };

  anubisXess = buildNpmPackage {
    inherit version src;
    pname = "${pname}-xess";

    npmDepsHash = "sha256-jiLrqn0jenug2ff/mqhOIfc7f+CsQja5g2K9n+W1kVM=";

    buildPhase = ''
      runHook preBuild
      npx postcss ./xess/xess.css -o xess.min.css
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp xess.min.css $out
      runHook postInstall
    '';
  };
in
buildGoModule (finalAttrs: {
  inherit pname version src;

  vendorHash = "sha256-v9GsTUzBYfjh6/ETBbFpN5dqMzMaOz8w39Xz1omaPJE=";

  nativeBuildInputs = [
    esbuild
    brotli
    zstd
  ];

  subPackages = [
    "cmd/anubis"
  ];

  ldflags =
    [
      "-s"
      "-w"
      "-X=github.com/TecharoHQ/anubis.Version=v${finalAttrs.version}"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "-extldflags=-static"
    ];

  postPatch = ''
    patchShebangs ./web/build.sh
  '';

  preBuild = ''
    go generate ./... && ./web/build.sh && cp -r ${anubisXess}/xess.min.css ./xess
  '';

  preCheck = ''
    export DONT_USE_NETWORK=1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Weighs the soul of incoming HTTP requests using proof-of-work to stop AI crawlers";
    homepage = "https://github.com/TecharoHQ/anubis/";
    changelog = "https://github.com/TecharoHQ/anubis/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      knightpp
      soopyc
      ryand56
    ];
    mainProgram = "anubis";
  };
})
