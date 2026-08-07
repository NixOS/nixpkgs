{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
  nixosTests,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  typescript,
  versionCheckHook,
}:

let
  pname = "autobrr";
  version = "1.82.1";
  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "autobrr";
    tag = "v${version}";
    hash = "sha256-dB/lk05v9L8GAF//N1We3byhsK+156rzRT+r9Q+EVD4=";
  };

  autobrr-web = stdenvNoCC.mkDerivation {
    pname = "${pname}-web";
    inherit src version;

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_11
      typescript
    ];

    sourceRoot = "${src.name}/web";

    pnpmDeps = fetchPnpmDeps {
      inherit (autobrr-web)
        pname
        version
        src
        sourceRoot
        ;
      pnpm = pnpm_11;
      fetcherVersion = 4;
      hash = "sha256-wlikd38tAfgaSSD9L7DiSXRQFYcfVq5YA1eWs5NE4n8=";
    };

    postBuild = ''
      pnpm run build
    '';

    installPhase = ''
      cp -r dist $out
    '';
  };
in
buildGoModule (finalAttrs: {
  inherit
    pname
    version
    src
    ;

  vendorHash = "sha256-tsGl0uiQV25aemEQvedZUISrlO4IPE+V87nl31m8hZI=";

  preBuild = ''
    cp -r ${finalAttrs.passthru.autobrr-web}/* web/dist
  '';

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${src.tag}"
  ];

  # In darwin, tests try to access /etc/protocols, which is not permitted.
  doCheck = !stdenv.hostPlatform.isDarwin;
  doInstallCheck = !stdenv.hostPlatform.isDarwin;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/autobrrctl";
  versionCheckProgramArg = "version";

  passthru = {
    inherit autobrr-web;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "autobrr-web"
      ];
    };
    tests.testService = nixosTests.autobrr;
  };

  meta = {
    description = "Modern, easy to use download automation for torrents and usenet";
    license = lib.licenses.gpl2Plus;
    homepage = "https://autobrr.com/";
    changelog = "https://autobrr.com/release-notes/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ av-gal ];
    mainProgram = "autobrr";
    platforms = with lib.platforms; darwin ++ freebsd ++ linux;
  };
})
