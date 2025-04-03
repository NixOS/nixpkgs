{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  perl,
  udev,
  openssl,
  gitMinimal,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "koji";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "cococonscious";
    repo = "koji";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+xtq4btFbOfiyFMDHXo6riSBMhAwTLQFuE91MUHtg5Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-WiFXDXLJc2ictv29UoRFRpIpAqeJlEBEOvThXhLXLJA=";

  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ udev ];

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    git config --global user.name 'nix-user'
    git config --global user.email 'nix-user@example.com'
  '';

  meta = {
    description = "Interactive CLI for creating conventional commits";
    homepage = "https://github.com/its-danny/koji";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ByteSudoer
      WeetHet
    ];
    mainProgram = "koji";
    platforms = lib.platforms.unix;
  };
})
