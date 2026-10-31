{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
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
  buildNpmPackage' = buildNpmPackage.override { nodejs = nodejs_22; };
in
buildGoModule (finalAttrs: {
  pname = "paisa";
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "ananthakumaran";
    repo = "paisa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UsuHoB+dLx0+VD9DM15rBLu+6gptFyvf9fAqEsauQnQ=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-th2jxlYseQjkIvu0mbUnNRzAFgHHTrm/lh4+CvonfWc=";
  frontend = buildNpmPackage' {
    pname = "paisa-frontend";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-QkYtUk/JhL+KC8/9uSd/oGjsjdmwZl47W2oZh3oRGGA=";

    # canvas fails to build with Node 22 (upstream nan/V8 incompatibility).
    # It is only used client-side via pdf-js, so the native binding is never
    # loaded. Other install scripts in this tree are no-ops or re-run during
    # `vite build`. See Automattic/node-canvas#2448.
    npmFlags = [ "--ignore-scripts" ];

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
    description = "Personal finance manager, building on top of the ledger double entry accounting tool";
    license = lib.licenses.agpl3Only;
    mainProgram = "paisa";
    maintainers = with lib.maintainers; [ skowalak ];
  };
})
