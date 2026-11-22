{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  aws-lc,
  stdenv,
  gcc,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "fh";
  version = "0.1.28";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "fh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AhWJPz50o+vlZiMbUr/0wcCsgHDfZjjrQGgyQzhjKBw=";
  };

  cargoHash = "sha256-JQ/AGfikMUYskRPyyo0AD2CD6jJ6eqPkgh6gyKRcfnw=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    rustPlatform.bindgenHook
  ];

  checkInputs = [ cacert ];

  buildInputs = [
    aws-lc
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    gcc.cc.lib
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_COMPILE = "-I${lib.getInclude stdenv.cc.libcxx}/include/c++/v1";
  };

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd fh --"$shell" <("$out/bin/fh" completion "$shell")
    done
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Official FlakeHub CLI";
    homepage = "https://github.com/DeterminateSystems/fh";
    changelog = "https://github.com/DeterminateSystems/fh/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "fh";
  };
})
