{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libxcb,
}:

rustPlatform.buildRustPackage rec {
  pname = "cotp";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "replydev";
    repo = "cotp";
    rev = "v${version}";
    hash = "sha256-Jv5BT7P/OXLkkfrEf+8x2IrACMhqr3zpbcKX8I/TzDc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9iZyi3TPnqRpt+SRI3t7kwwiGpwUjQ0BrLZQY3X383o=";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libxcb ];

  meta = with lib; {
    homepage = "https://github.com/replydev/cotp";
    description = "Trustworthy, encrypted, command-line TOTP/HOTP authenticator app with import functionality";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ davsanchez ];
    mainProgram = "cotp";
  };
}
