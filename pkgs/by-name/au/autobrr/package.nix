{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
  nodejs,
  pnpm_9,
  typescript,
  versionCheckHook,
}:

let
  pname = "autobrr";
  version = "1.59.0";
  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "autobrr";
    tag = "v${version}";
    hash = "sha256-etVhOgE8H8bWuraBepwDSZZzo9Xl819w2sT+UwpUVjM=";
  };

  autobrr-web = stdenvNoCC.mkDerivation {
    pname = "${pname}-web";
    inherit src version;

    nativeBuildInputs = [
      nodejs
      pnpm_9.configHook
      typescript
    ];

    sourceRoot = "${src.name}/web";

    pnpmDeps = pnpm_9.fetchDeps {
      inherit (autobrr-web)
        pname
        version
        src
        sourceRoot
        ;
      hash = "sha256-FzYgJvPk2RYC55LON9Wk6q6Fm2RpVeNKm/EH+KZF1hM=";
    };

    postBuild = ''
      pnpm run build
    '';

    installPhase = ''
      cp -r dist $out
    '';
  };
in
buildGoModule rec {
  inherit
    autobrr-web
    pname
    version
    src
    ;

  vendorHash = "sha256-fX2bXF2buXt/T1tfkybq8r9t5MWLGa3Wa+qVMx7z1Jc=";

  preBuild = ''
    cp -r ${autobrr-web}/* web/dist
  '';

  ldflags = [
    "-X main.version=${version}"
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
    changelog = "https://autobrr.com/release-notes/v${version}";
    maintainers = with lib.maintainers; [ av-gal ];
    mainProgram = "autobrr";
    platforms = with lib.platforms; darwin ++ freebsd ++ linux;
  };
}
