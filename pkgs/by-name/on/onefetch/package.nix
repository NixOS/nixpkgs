{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  installShellFiles,
  pkg-config,
  zstd,
  stdenv,
  darwin,
  gitMinimal,
}:

let
  inherit (darwin) libresolv;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "onefetch";
  version = "3.2.0";
  # Use the system zstd library.
  env.ZSTD_SYS_USE_PKG_CONFIG = "1";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = "onefetch";
    tag = finalAttrs.version;
    hash = "sha256-deGpYwdqCSYPGtM2GaecwCXCCE3wixTbdot6YwjfImk=";
  };

  cargoHash = "sha256-omR/5jKnjDWta1gj7e0Zha5B9IlzBdm16YJf8fOTDdk=";

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
  ];
  buildInputs = [
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libresolv
  ];

  nativeCheckInputs = [
    gitMinimal
  ];

  preCheck = ''
    git init
    git config user.name nixbld
    git config user.email nixbld@example.com
    git add .
    git commit -m test
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd onefetch \
      --bash <($out/bin/onefetch --generate bash) \
      --fish <($out/bin/onefetch --generate fish) \
      --zsh <($out/bin/onefetch --generate zsh)
  '';

  meta = {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    changelog = "https://github.com/o2sh/onefetch/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kloenk
    ];
    mainProgram = "onefetch";
  };
})
