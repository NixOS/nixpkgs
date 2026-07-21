{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  stdenvNoCC,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  nodejs-slim,
  pnpm_10,
  installShellFiles,
  nix-update-script,
  nixosTests,
}:

let
  version = "2.63.18";

  src = fetchFromGitHub {
    owner = "filebrowser";
    repo = "filebrowser";
    tag = "v${version}";
    hash = "sha256-0j0i6bKKbyUi4O0wBT+xYjvywjRzAGd0/13Yh/dG5GA=";
  };

  frontend = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "filebrowser-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";

    nativeBuildInputs = [
      nodejs-slim
      pnpmConfigHook
      pnpmBuildHook
      pnpm_10
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      fetcherVersion = 3;
      pnpm = pnpm_10;
      hash = "sha256-UwTA7Eogp2GrvmXDbdfGBTJS3DuOTJ42e6fHlQxSHoA=";
    };

    installPhase = ''
      runHook preInstall

      mkdir $out
      mv dist $out

      runHook postInstall
    '';
  });

in
buildGoModule {
  pname = "filebrowser";
  inherit version src;

  vendorHash = "sha256-BXw+fURCh1qNlwWo49aXIpSM339bV3Gwn9Ov8HLEVF0=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd filebrowser \
      --bash <($out/bin/filebrowser completion bash) \
      --fish <($out/bin/filebrowser completion fish) \
      --zsh  <($out/bin/filebrowser completion zsh )
  '';

  excludedPackages = [ "tools" ];

  preBuild = ''
    cp -r ${frontend}/dist frontend/
  '';

  ldflags = [
    "-X github.com/filebrowser/filebrowser/v2/version.Version=v${version}"
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };
    inherit frontend;
    tests = {
      inherit (nixosTests) filebrowser;
    };
  };

  meta = {
    description = "Web application for managing files and directories";
    homepage = "https://filebrowser.org";
    changelog = "https://github.com/filebrowser/filebrowser/releases/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ oakenshield ];
    mainProgram = "filebrowser";
  };
}
