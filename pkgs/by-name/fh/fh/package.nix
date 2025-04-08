{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  darwin,
  gcc,
  libcxx,
  cacert,
}:

rustPlatform.buildRustPackage rec {
  pname = "fh";
  version = "0.1.22";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "fh";
    rev = "v${version}";
    hash = "sha256-yOqXcn/OMfC97t002V8yzZn1PhuV8lIp5szPA7eys1Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+6/gTY0pqpsq8QByVLbC1KnT2G1CJwLtpIFrUnyzlU0=";

  nativeBuildInputs = [
    installShellFiles
    rustPlatform.bindgenHook
  ];

  checkInputs = [ cacert ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
    gcc.cc.lib
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_COMPILE = "-I${lib.getDev libcxx}/include/c++/v1";
  };

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fh \
      --bash <($out/bin/fh completion bash) \
      --fish <($out/bin/fh completion fish) \
      --zsh <($out/bin/fh completion zsh)
  '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Official FlakeHub CLI";
    homepage = "https://github.com/DeterminateSystems/fh";
    changelog = "https://github.com/DeterminateSystems/fh/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fh";
  };
}
