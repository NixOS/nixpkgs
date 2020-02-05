{ stdenv, lib, fetchFromGitHub, autoreconfHook, go-md2man, pkgconfig
, libcap, libseccomp, python3, systemd, yajl }:

stdenv.mkDerivation rec {
  pname = "crun";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = version;
    sha256 = "0sxpdv3afh8hn39jdg06vwkyp7i6dsyf1gg8719vwiwmcbhzj8mx";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoreconfHook go-md2man pkgconfig python3 ];

  buildInputs = [ libcap libseccomp systemd yajl ];

  enableParallelBuilding = true;

  preBuild = ''
    cat > git-version.h <<EOF
    #ifndef GIT_VERSION
    # define GIT_VERSION "nixpkgs-${version}"
    #endif
    EOF
  '';

  # the tests require additional permissions
  doCheck = false;

  meta = with lib; {
    description = "A fast and lightweight fully featured OCI runtime and C library for running containers";
    license = licenses.gpl3;
    platforms = platforms.linux;
    inherit (src.meta) homepage;
  };
}
