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
    sha256 = "1k77kxqszdwgrb50w7algj22pb4fy5b9649cjb08zq9fqrzxcbz7";
  };

  cmakeFlags = [
    "-DCMAKE_OSX_ARCHITECTURES=${stdenv.hostPlatform.darwinArch}"
    "-DENABLE_CLI=ON"
  ];

  buildInputs = [ openpam ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/fabianishere/pam_reattach";
    description = "Reattach to the user's GUI session on macOS during authentication (for Touch ID support in tmux)";
    license = licenses.mit;
    maintainers = with maintainers; [ lockejan ];
    platforms = platforms.darwin;
  };
}
