{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "catimg";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "posva";
    repo = "catimg";
    rev = version;
    sha256 = "0a2dswbv4xddb2l2d55hc43lzvjwrjs5z9am7v6i0p0mi2fmc89s";
  };

  patches = [
    # Update CMake minimum required version for CMake 4 compatibility
    # https://github.com/NixOS/nixpkgs/issues/449801
    # https://github.com/posva/catimg/pull/73
    (fetchpatch {
      url = "https://github.com/posva/catimg/commit/155786229230e2ddc2dd97e4e0219d1e2aa66099.patch";
      hash = "sha256-eDXYa8eGvhC7NGL6V+R3Ui5FBtx/APGUC6Sw9rv2ho4=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  env = lib.optionalAttrs (stdenv.hostPlatform.libc == "glibc") {
    CFLAGS = "-D_DEFAULT_SOURCE";
  };

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/posva/catimg";
    description = "Insanely fast image printing in your terminal";
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
    mainProgram = "catimg";
  };

}
