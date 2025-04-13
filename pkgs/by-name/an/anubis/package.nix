{
  lib,
  buildGo124Module,
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
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "TecharoHQ";
    repo = "anubis";
    tag = "v${version}";
    hash = "sha256-/7GMf0QGR0rtz05vHN/yYYuzxN25NhqidITdAf6jSXY=";
  };

  anubisXess = buildNpmPackage {
    inherit version src;
    pname = "${pname}-xess";

    npmDepsHash = "sha256-QrW0grgNRZRum2mCec86Za1UV4R5QSRlhjVYFsZDwY8=";

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
buildGo124Module rec {
  inherit pname version src;

  vendorHash = "sha256-D0+SDJIagAPqd71fIHCh29vPMVL0ZZAFg0rmgW2EaGw=";

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
      "-X=github.com/TecharoHQ/anubis.Version=v${version}"
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
    changelog = "https://github.com/TecharoHQ/anubis/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      knightpp
      soopyc
    ];
    mainProgram = "anubis";
  };
}
