{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  gcc,
  cacert,
}:

<<<<<<< HEAD
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fh";
  version = "0.1.27";
=======
rustPlatform.buildRustPackage rec {
  pname = "fh";
  version = "0.1.26";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "fh";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-EUCV7/J9wJRroCGW5JqonFJIqcvJEBAwB7l3eWYxiSk=";
  };

  cargoHash = "sha256-HOQqUNd0I85lAD6YVWT9baEj31JpjIgq9Ujfn4ys/3o=";
=======
    rev = "v${version}";
    hash = "sha256-cHXpTe5tAXrAwVu5+ZTb3pzHIqAk353GnNFPvComIfQ=";
  };

  cargoHash = "sha256-HwFehxL01pwT93jjVvCU9BXhaHhCDbox50ecXpod3Mo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Official FlakeHub CLI";
    homepage = "https://github.com/DeterminateSystems/fh";
    changelog = "https://github.com/DeterminateSystems/fh/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "fh";
  };
})
=======
  meta = with lib; {
    description = "Official FlakeHub CLI";
    homepage = "https://github.com/DeterminateSystems/fh";
    changelog = "https://github.com/DeterminateSystems/fh/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "fh";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
