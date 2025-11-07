{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  installShellFiles,
  versionCheckHook,
  stdenv,
  nixosTests,
}:

let
  pname = "artalk";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "ArtalkJS";
    repo = "artalk";
    tag = "v${version}";
    hash = "sha256-gzagE3muNpX/dwF45p11JAN9ElsGXNFQ3fCvF1QhvdU=";
  };

  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "${pname}-frontend";

    inherit src version;

    nativeBuildInputs = [
      nodejs
      pnpm_9.configHook
    ];

    pnpmDeps = pnpm_9.fetchDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 1;
      hash = "sha256-QIfadS2gNPtH006O86EndY/Hx2ml2FoKfUXJF5qoluw=";
    };

    buildPhase = ''
      runHook preBuild

      pnpm build:all
      pnpm build:auth

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{dist/{i18n,plugins},sidebar}

      # dist
      cp ./ui/artalk/dist/{Artalk,ArtalkLite}.{css,js} $out/dist
      cp ./ui/artalk/dist/i18n/*.js $out/dist/i18n
      cp ./ui/plugin-*/dist/*.js $out/dist/plugins

      # sidebar
      cp -r ./ui/artalk-sidebar/dist/* $out/sidebar

      runHook postInstall
    '';
  });
in
buildGoModule {
  inherit src pname version;

  vendorHash = "sha256-oAqYQzOUjly97H5L5PQ9I2SO2KqiUVxdJA+eoPrHD6Q=";

  ldflags = [
    "-s"
    "-w"
  ];

  preBuild = ''
    cp -r ${frontend}/* ./public
  '';

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd artalk \
      --bash <($out/bin/artalk completion bash) \
      --fish <($out/bin/artalk completion fish) \
      --zsh <($out/bin/artalk completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";

  passthru.tests = {
    inherit (nixosTests) artalk;
  };

  meta = {
    description = "Self-hosted comment system";
    homepage = "https://github.com/ArtalkJS/Artalk";
    changelog = "https://github.com/ArtalkJS/Artalk/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "artalk";
  };
}
