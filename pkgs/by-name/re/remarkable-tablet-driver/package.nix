{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  libssh,
}:

stdenv.mkDerivation {
  pname = "remarkable-tablet-driver";
  version = "unstable-2025-10-28";

  src = fetchFromGitHub {
    owner = "FreeCap23";
    repo = "reMarkable-tablet-driver";
    rev = "dab7a35c2fc82a8c9173b9685dcda4a45d881165";
    sha256 = "sha256-AQhDKzxN+Gkuv0W+P53Xh4pM/iiq8zvKacPXMPYlbW8=";
  };

  # Build errors when format hardening is enabled:
  #   cc1: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]
  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libssh
  ];

  meta = with lib; {
    description = "A userspace tablet driver on Linux for the reMarkable Paper Table";
    mainProgram = "rmTabletDriver";
    homepage = "https://github.com/FreeCap23/reMarkable-tablet-driver";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
