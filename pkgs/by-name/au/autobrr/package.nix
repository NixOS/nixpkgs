{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  typescript,
  versionCheckHook,
}:

let
  pname = "autobrr";
  version = "1.72.1";
  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "autobrr";
    tag = "v${version}";
    hash = "sha256-COrcR4SjP5JNdjo/AsDvl9kSG+K7e8/bkZiHwA6jEGA=";
  };

  autobrr-web = stdenvNoCC.mkDerivation {
    pname = "${pname}-web";
    inherit src version;

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm_9
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
      pnpm = pnpm_9;
      fetcherVersion = 1;
      hash = "sha256-h3f6fCV83XMiz6Beuzout/xUT09iI0dbyc/Z1R4Z8lQ=";
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

  vendorHash = "sha256-9FRJywR1fza8VKjEXHnl7rAYclKme1mTKHI02OcrUw0=";

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
