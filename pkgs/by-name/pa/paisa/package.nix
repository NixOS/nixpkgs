{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  versionCheckHook,
  nixosTests,
}:

let
  buildNpmPackage' = buildNpmPackage.override { nodejs = nodejs_24; };
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

    # canvas fails to build with GCC 16 on Node 24. Paisa uses PDF.js in the
    # browser, the optional native canvas binding is not needed.
    npmFlags = [ "--ignore-scripts" ];

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
