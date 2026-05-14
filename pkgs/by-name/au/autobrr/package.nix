{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
  nixosTests,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  typescript,
  versionCheckHook,
}:

let
  pname = "autobrr";
  version = "1.77.1";
  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "autobrr";
    tag = "v${version}";
    hash = "sha256-XNTQmW8JUxe8bffe1eGvxoRQ3rKdoH0QQKDn/wY6L3o=";
  };

  autobrr-web = stdenvNoCC.mkDerivation {
    pname = "${pname}-web";
    inherit src version;

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_10
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
      pnpm = pnpm_10;
      fetcherVersion = 3;
      hash = "sha256-StLGK3Oezv+M5tuFd1rZyLpG0g1xFxWPJ5lm39Sy0FQ=";
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

  vendorHash = "sha256-POqFXcLtc18EzEQ2SRb2+D+3E8KexaAOelgOSvCwoWI=";

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
