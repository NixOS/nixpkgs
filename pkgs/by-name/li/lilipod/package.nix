{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "lilipod";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "89luca89";
    repo = "lilipod";
    rev = "v${version}";
    hash = "sha256-PqeYNLr4uXe+H+DLENlUpl1H2wV6VJvDoA+MVP3SRqY=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    runHook preBuild

    RELEASE_VERSION=${version} make all

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    make coverage

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 lilipod $out/bin/lilipod

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd lilipod \
      --bash <($out/bin/lilipod completion bash) \
      --fish <($out/bin/lilipod completion fish) \
      --zsh <($out/bin/lilipod completion zsh)
  '';

  meta = {
    description = "Very simple (as in few features) container and image manager";
    longDescription = ''
      Lilipod is a very simple container manager with minimal features to:

      - Download and manager images
      - Create and run containers

      It tries to keep a somewhat compatible CLI interface with Podman/Docker/Nerdctl.
    '';
    homepage = "https://github.com/89luca89/lilipod";
    license = lib.licenses.gpl3Only;
    mainProgram = "lilipod";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
