{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  stdenv,

  anubis-xess,

  esbuild,
  brotli,
  zstd,
}:

buildGoModule (finalAttrs: {
  pname = "anubis";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "TecharoHQ";
    repo = "anubis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-grtzkNxgShbldjm+lnANbKVhkUrbwseAT1NaBL85mHg=";
  };

  vendorHash = "sha256-EOT/sdVINj9oO1jZHPYB3jQ+XApf9eCUKuMY0tV+vpg=";

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
    go generate ./... && ./web/build.sh && cp -r ${anubis-xess}/xess.min.css ./xess
  '';

  preCheck = ''
    export DONT_USE_NETWORK=1
  '';

  passthru.tests = { inherit (nixosTests) anubis; };

  meta = {
    description = "Weighs the soul of incoming HTTP requests using proof-of-work to stop AI crawlers";
    homepage = "https://anubis.techaro.lol/";
    changelog = "https://github.com/TecharoHQ/anubis/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      knightpp
      soopyc
      ryand56
      sigmasquadron
    ];
    mainProgram = "anubis";
  };
})
