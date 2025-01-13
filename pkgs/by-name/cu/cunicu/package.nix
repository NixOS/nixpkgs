{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  protobuf,
  protoc-gen-go,
  protoc-gen-go-grpc,
  nix-update-script,
}:
buildGoModule rec {
  pname = "cunicu";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "cunicu";
    repo = "cunicu";
    rev = "v${version}";
    hash = "sha256-rUUJMvT3JkIehoWLOtruUSU8YbKd6mS7Wp2TXwn9aVE=";
  };

  vendorHash = "sha256-yFpkYI6ue5LXwRCj4EqWDBaO3TYzZ3Ov/39PRQWMWzk=";

  nativeBuildInputs = [
    installShellFiles
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  env.CGO_ENABLED = 0;

  # These packages contain networking dependent tests which fail in the sandbox
  excludedPackages = [
    "pkg/config"
    "pkg/selfupdate"
    "pkg/tty"
    "scripts"
  ];

  ldflags = [
    "-X cunicu.li/cunicu/pkg/buildinfo.Version=${version}"
    "-X cunicu.li/cunicu/pkg/buildinfo.BuiltBy=Nix"
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  preBuild = ''
    go generate ./...
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/cunicu docs --with-frontmatter
    installManPage ./docs/usage/man/*.1
    installShellCompletion --cmd cunicu \
      --bash <($out/bin/cunicu completion bash) \
      --zsh <($out/bin/cunicu completion zsh) \
      --fish <($out/bin/cunicu completion fish)
  '';

  meta = {
    description = "Zeroconf peer-to-peer mesh VPN using Wireguard® and Interactive Connectivity Establishment (ICE)";
    homepage = "https://cunicu.li";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ stv0g ];
    platforms = lib.platforms.linux;
    mainProgram = "cunicu";
  };
}
