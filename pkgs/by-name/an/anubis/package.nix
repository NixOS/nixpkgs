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
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "TecharoHQ";
    repo = "anubis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LOYBl9r00AJljGvlacd506cLeMr8Ndh817/ZIw46Uu0=";
  };

  postPatch = ''
    substituteInPlace lib/challenge/preact/preact.go \
      --replace-fail "//go:generate ./build.sh" ""
  '';

  vendorHash = "sha256-/iTAbwYSHTz9SrJ0vrAXsA+3yS0jUreJDF52gju9CgU=";

  assets = buildNpmPackage {
    pname = "anubis-assets";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-s+OxVf6Iysobfuo0nAh5qF157opD2sR5D+7awAx6GTs=";

    nativeBuildInputs = [
      esbuild
      brotli
      zstd
    ];

    postPatch = ''
      patchShebangs ./web/build.sh ./lib/challenge/preact/build.sh
    '';

    buildPhase = ''
      runHook preBuild

      ./web/build.sh && ./lib/challenge/preact/build.sh
      npx postcss ./xess/xess.css -o xess.min.css

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{web,preact,xess}

      cp -r web/static/* $out/web
      cp -r lib/challenge/preact/static/* $out/preact
      install -Dm644 xess.min.css $out

      runHook postInstall
    '';
  };

  subPackages = [ "cmd/anubis" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/TecharoHQ/anubis.Version=v${finalAttrs.version}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ "-extldflags=-static" ];

  preBuild = ''
    go generate ./...

    cp -r ${finalAttrs.assets}/web/* ./web/static
    cp -r ${finalAttrs.assets}/preact/* ./lib/challenge/preact/static
    install -Dm644 ${finalAttrs.assets}/xess.min.css -t xess
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
