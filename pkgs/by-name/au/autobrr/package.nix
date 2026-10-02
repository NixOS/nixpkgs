{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
  nixosTests,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  versionCheckHook,
}:

let
  pname = "autobrr";
  version = "1.87.0";
  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "autobrr";
    tag = "v${version}";
    hash = "sha256-u0gcSgexI8Rw9Fsh6xcb0dDmCxbghAyXVIyUG6jtq9g=";
  };

  autobrr-web = stdenvNoCC.mkDerivation {
    pname = "${pname}-web";
    inherit src version;

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_11
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
      hash = "sha256-GBe6c0sjj/gaLOrtGVmcjaQ5c7E9mhYvbLhRSViv7s8=";
    };

    postBuild = ''
      pnpm run build
    '';

    installPhase = ''
      cp -r dist $out
    '';
  };
in
buildGo127Module (finalAttrs: {
  inherit
    pname
    version
    src
    ;

  vendorHash = "sha256-Mo+XAYe1bNVO89dDBoMsBnxcxhEgu/EdwqrA5RUjSrw=";

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
