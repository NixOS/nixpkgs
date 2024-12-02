{
  buildGoModule,
  darwin,
  fetchFromGitHub,
  installShellFiles,
  kclvm_cli,
  kclvm,
  lib,
  makeWrapper,
  nix-update-script,
  stdenv,
}:

buildGoModule rec {
  pname = "kcl";
  version = "0.10.9";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-V9HLUv018gCkzrt1mGNENZVjXCSvqEneQIgIwxawxKM=";
  };

  vendorHash = "sha256-y8KWiy6onZmYdpanXcSQDmYv51pLfo1NTdg+EaR6p0E=";

  subPackages = [ "cmd/kcl" ];

  ldflags = [
    "-w -s"
    "-X=kcl-lang.io/cli/pkg/version.version=v${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildInputs =
    [
      kclvm
      kclvm_cli
    ]
    ++ (lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.SystemConfiguration
    ]);

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export HOME=$(mktemp -d)
    for shell in bash fish zsh; do
      installShellCompletion --cmd kcl \
        --$shell <($out/bin/kcl completion $shell)
    done
  '';

  # By default, libs and bins are stripped. KCL will crash on darwin if they are.
  dontStrip = stdenv.hostPlatform.isDarwin;

  # env vars https://github.com/kcl-lang/kcl-go/blob/main/pkg/env/env.go#L29
  postFixup = ''
    wrapProgram $out/bin/kcl \
      --prefix PATH : "${
        lib.makeBinPath [
          kclvm
          kclvm_cli
        ]
      }" \
      --prefix KCL_LIB_HOME : "${lib.makeLibraryPath [ kclvm ]}" \
      --prefix KCL_GO_DISABLE_INSTALL_ARTIFACT : false
  '';

  updateScript = nix-update-script { };

  meta = {
    description = "A command line interface for KCL programming language";
    changelog = "https://github.com/kcl-lang/cli/releases/tag/v${version}";
    homepage = "https://github.com/kcl-lang/cli";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      peefy
      selfuryon
    ];
    mainProgram = "kcl";
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
}
