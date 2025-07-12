{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_20,
  versionCheckHook,
  node-gyp,
  python3,
  pkg-config,
  cairo,
  giflib,
  libjpeg,
  libpng,
  librsvg,
  pango,
  pixman,
  nixosTests,
}:

let
  # paisa docker builds with nodejs 22, but we need node 20 so we can build
  # node-canvas from source (which currently fails with nodejs 22 due to some
  # deprecations in the v8 javascript engine and nan c++
  buildNpmPackage' = buildNpmPackage.override { nodejs = nodejs_20; };
in
buildGoModule (finalAttrs: {
  pname = "paisa";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "ananthakumaran";
    repo = "paisa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nJpyqEOlXNvnMvheWtfUMARBgQRk8TpXHyVsXDxJ3oo=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-KnHJ6+aMahTeNdbRcRAgBERGVYen/tM/tDcFI/NyLdE=";
  frontend = buildNpmPackage' {
    pname = "paisa-frontend";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-8LPW9pcipVMWuZ4wOlpAOaRdT5o1gom39gqcfmhY1eE=";

    buildInputs = [
      # needed for building node-canvas from source which is a dependency of
      # pdfjs
      # https://github.com/Automattic/node-canvas/blob/master/Readme.md#compiling
      cairo
      giflib
      libjpeg
      libpng
      librsvg
      pango
      pixman
    ];

    nativeBuildInputs = [
      (python3.withPackages (ps: with ps; [ distutils ]))
      pkg-config
      node-gyp
    ];

    postBuild = ''
      mkdir -p $out/web/
      cp -r web/static $out/web/
    '';
  };

  env.CGO_ENABLED = 1;

  doCheck = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";

  preBuild = ''
    cp -r ${finalAttrs.frontend}/web/static ./web
  '';

  passthru = {
    inherit (finalAttrs) frontend;
    tests = {
      inherit (nixosTests) paisa;
    };
  };

  meta = {
    homepage = "https://paisa.fyi/";
    changelog = "https://github.com/ananthakumaran/paisa/releases/tag/v${finalAttrs.version}";
    description = "Paisa is a Personal finance manager. It builds on top of the ledger double entry accounting tool.";
    license = lib.licenses.agpl3Only;
    mainProgram = "paisa";
    maintainers = with lib.maintainers; [ skowalak ];
  };
})
