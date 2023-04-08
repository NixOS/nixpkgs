{ lib, stdenv, fetchFromGitHub, which, zstd, pbzip2 }:

stdenv.mkDerivation rec {
  version = "2.4.5";
  pname = "makeself";

  src = fetchFromGitHub {
    owner = "megastep";
    repo = "makeself";
    rev = "release-${version}";
    fetchSubmodules = true;
    sha256 = "sha256-15lUtErGsbXF2Gn0f0rvA18mMuVMmkKrGO2poeYZU9g=";
  };

  postPatch = "patchShebangs test";

  # Issue #110149: our default /bin/sh apparently has 32-bit math only
  # (attribute busybox-sandbox-shell), and that causes problems
  # when running these tests inside build, based on free disk space.
  doCheck = false;
  checkTarget = "test";
  nativeCheckInputs = [ which zstd pbzip2 ];

  installPhase = ''
    mkdir -p $out/{bin,share/{${pname}-${version},man/man1}}
    cp makeself.lsm README.md $out/share/${pname}-${version}
    cp makeself.sh $out/bin/makeself
    cp makeself.1  $out/share/man/man1/
    cp makeself-header.sh $out/share/${pname}-${version}
  '';

  fixupPhase = ''
    sed -e "s|^HEADER=.*|HEADER=$out/share/${pname}-${version}/makeself-header.sh|" -i $out/bin/makeself
  '';

  meta = with lib; {
    homepage = "https://makeself.io";
    description = "Utility to create self-extracting packages";
    license = licenses.gpl2;
    maintainers = [ maintainers.wmertens ];
    platforms = platforms.all;
  };
}
