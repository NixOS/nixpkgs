{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openpam,
}:

stdenv.mkDerivation rec {
  pname = "pam_reattach";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "fabianishere";
    repo = "pam_reattach";
    rev = "v${version}";
    hash = "sha256-5y/Wf8Yu4Y/AkiwRk1bxjqwrhHxUHQ7Kyo+3r3Gf58w=";
  };

  cmakeFlags = [
    "-DCMAKE_OSX_ARCHITECTURES=${stdenv.hostPlatform.darwinArch}"
    "-DENABLE_CLI=ON"
  ];

  buildInputs = [ openpam ];

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/fabianishere/pam_reattach";
    description = "Reattach to the user's GUI session on macOS during authentication (for Touch ID support in tmux)";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lockejan ];
    platforms = lib.platforms.darwin;
  };
}
