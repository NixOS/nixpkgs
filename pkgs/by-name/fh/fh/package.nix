{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  gcc,
  cacert,
}:

rustPlatform.buildRustPackage rec {
  pname = "fh";
  version = "0.1.24";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "fh";
    rev = "v${version}";
    hash = "sha256-t7IZlG7rKNbkt2DIU5H0/B0+b4e9YEVJx14ijpOycCw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-IXzqcIVk7F/MgWofzlwEkXfu7s8e7GdjYhdFbXUTeeo=";

  nativeBuildInputs = [
    installShellFiles
    rustPlatform.bindgenHook
  ];

  checkInputs = [ cacert ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    gcc.cc.lib
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_COMPILE = "-I${lib.getInclude stdenv.cc.libcxx}/include/c++/v1";
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
