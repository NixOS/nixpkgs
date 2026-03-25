{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  typescript,
  versionCheckHook,
}:

let
  pname = "autobrr";
  version = "1.75.1";
  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "autobrr";
    tag = "v${version}";
    hash = "sha256-y1whIPx4s399WmO2xzjLFXPKhINE9b3+jHJcmsP+3ZA=";
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
      hash = "sha256-euDGtNERNq3IgxggiHoLmcq2+e2SslXLSfY8TTFnqoE=";
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
    autobrr-web
    pname
    version
    src
    ;

  vendorHash = "sha256-kxly/+7wnPbxs1LKzoSFRYcPBWqZg4tgzV3uYJji+yA=";

  preBuild = ''
    cp -r ${autobrr-web}/* web/dist
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "autobrr-web"
    ];
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
