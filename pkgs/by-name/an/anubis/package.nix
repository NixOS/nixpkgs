{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  stdenv,
  buildNpmPackage,

  esbuild,
  brotli,
  zstd,
}:

buildGoModule (finalAttrs: {
  pname = "anubis";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "TecharoHQ";
    repo = "anubis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pdfe2D9KAg/vesTgOi+b5ZVkUkuWhmZC/xYXiiYzlPs=";
  };

  vendorHash = "sha256-cOl+eVnj6aMKIJCjCM0aacp4/Jg5BhZqFwum+u9tOKE=";

  nativeBuildInputs = [
    esbuild
    brotli
    zstd
  ];

  xess = buildNpmPackage {
    pname = "anubis-xess";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-kBnexaBAMgA7QdKevW3mmlSn+QEbkTW//hYVTRFLQeQ=";

    buildPhase = ''
      runHook preBuild
      npx postcss ./xess/xess.css -o xess.min.css
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm644 xess.min.css $out/xess.min.css
      runHook postInstall
    '';
  };

  subPackages = [ "cmd/anubis" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/TecharoHQ/anubis.Version=v${finalAttrs.version}"
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ "-extldflags=-static" ];

  postPatch = ''
    patchShebangs ./web/build.sh
  '';

  preBuild = ''
    go generate ./... && ./web/build.sh && cp -r ${finalAttrs.xess}/xess.min.css ./xess
  '';

  preCheck = ''
    export DONT_USE_NETWORK=1
  '';

  passthru.tests = { inherit (nixosTests) anubis; };
  passthru.updateScript = ./update.sh;

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
      sigmasquadron
      defelo
    ];
    mainProgram = "anubis";
  };
})
