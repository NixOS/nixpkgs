{
  lib,
  stdenv,
  fetchFromGitHub,
  fuse,
  p7zip,
  autoconf,
  automake,
  pkg-config,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "fuse-7z-ng";
  version = "unstable-2014-06-08";

  src = fetchFromGitHub {
    owner = "kedazo";
    repo = pname;
    rev = "eb5efb1f304c2b7bc2e0389ba06c9bf2ac4b932c";
    sha256 = "17v1gcmg5q661b047zxjar735i4d3508dimw1x3z1pk4d1zjhp3x";
  };
  patches = [
    # Drop unused pthread library. pthread_yield()
    # fails the configure.
    ./no-pthread.patch
    # Zero-initialize unset fields of `struct fuse_operations` so that
    # garbage values don't cause segfault.
    # <https://github.com/kedazo/fuse-7z-ng/pull/8>
    ./zero-init-fuse-operations.patch
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    autoconf
    automake
  ];
  buildInputs = [ fuse ];

  preConfigure = "./autogen.sh";

  libs = lib.makeLibraryPath [ p7zip ]; # 'cause 7z.so is loaded manually
  postInstall = ''
    wrapProgram $out/bin/${pname} --suffix LD_LIBRARY_PATH : "${libs}/p7zip"

    mkdir -p $out/share/doc/${pname}
    cp TODO README NEWS COPYING ChangeLog AUTHORS $out/share/doc/${pname}/
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "FUSE-based filesystem that uses the p7zip library";
    longDescription = ''
      fuse-7z-ng is a FUSE file system that uses the p7zip
      library to access all archive formats supported by 7-zip.

      This project is a fork of fuse-7z ( https://gitorious.org/fuse-7z/fuse-7z ).
    '';
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    mainProgram = "fuse-7z-ng";
  };
}
