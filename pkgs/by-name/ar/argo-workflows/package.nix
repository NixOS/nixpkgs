{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  iana-etc,
  libredirect,
  pkgsBuildBuild,
}:

buildGoModule (finalAttrs: {
  pname = "argo-workflows";
  version = "4.1.6";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo-workflows";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HBWtjVJ3aPvus1luNRProRz7lWcDNg0nOsRH31COAJE=";
  };

  vendorHash = "sha256-omXobtLJIQWolpt8KwkBg3F0jqP2ntLOht6MaTdgC3Y=";

  doCheck = false;

  subPackages = [
    "cmd/argo"
  ];

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.buildPlatform.isDarwin [ libredirect.hook ];

  preBuild = ''
    mkdir -p ui/dist/app
    # This build target could act as a web server, but this is just
    # acting as a CLI.
    # Provide a dummy UI file to allow the build to embed something
    # without actually building the web content
    echo "Built without static files" > ui/dist/app/index.html
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/argoproj/argo-workflows/v4.buildDate=unknown"
    "-X github.com/argoproj/argo-workflows/v4.gitCommit=${finalAttrs.src.rev}"
    "-X github.com/argoproj/argo-workflows/v4.gitTag=${finalAttrs.src.rev}"
    "-X github.com/argoproj/argo-workflows/v4.gitTreeState=clean"
    "-X github.com/argoproj/argo-workflows/v4.version=${finalAttrs.version}"
  ];

  # modernc.org/libc reads /etc/protocols and /etc/services during package
  # init. It falls back to a built-in table when they do not exist, but panics
  # when they exist and are unreadable, which is what the Darwin sandbox
  # produces. Redirect them so the completion generation below can run.
  postInstall =
    lib.optionalString stdenv.buildPlatform.isDarwin ''
      export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/services=${iana-etc}/etc/services
    ''
    + ''
      for shell in bash zsh fish; do
        ${
          if (stdenv.buildPlatform == stdenv.hostPlatform) then
            "$out/bin/argo"
          else
            "${pkgsBuildBuild.argo-workflows}/bin/argo"
        } completion $shell > argo.$shell
        installShellCompletion argo.$shell
      done
    '';

  meta = {
    description = "Container native workflow engine for Kubernetes";
    mainProgram = "argo";
    homepage = "https://github.com/argoproj/argo-workflows";
    changelog = "https://github.com/argoproj/argo-workflows/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      groodt
      joibel
    ];
    platforms = lib.platforms.unix;
  };
})
