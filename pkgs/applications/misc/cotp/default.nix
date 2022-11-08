{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  AppKit,
  libxcb,
}:
rustPlatform.buildRustPackage rec {
  name = "cotp";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "replydev";
    repo = "cotp";
    rev = "v${version}";
    sha256 = "sha256-SbS+ch7/45kZb49jW2mnRWQruLrfrNfeZFqEPHQKGUg=";
  };

  cargoSha256 = "sha256-2lIR3K4/hr4XSmNGFd/dhwoFOtEB9KSnUrZkcaCyc9k=";

  buildInputs =
    lib.optionals stdenv.isLinux [libxcb]
    ++ lib.optionals stdenv.isDarwin [AppKit];

  meta = with lib; {
    homepage = "https://github.com/replydev/cotp";
    description = "Trustworthy, encrypted, command-line TOTP/HOTP authenticator app with import functionality";
    license = licenses.gpl3;
    maintainers = with maintainers; [davsanchez];
    platforms = ["x86_64-linux" "aarch64-darwin"];
  };
}
