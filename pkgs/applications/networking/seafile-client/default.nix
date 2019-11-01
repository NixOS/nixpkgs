{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, cmake, qtbase, qttools
, seafile-shared, ccnet
, withShibboleth ? true, qtwebengine }:

with stdenv.lib;

mkDerivation rec {
  version = "6.2.11";
  pname = "seafile-client";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-client";
    rev = "v${version}";
    sha256 = "1b8jqmr2qd3bpb3sr4p5w2a76x5zlknkj922sxrvw1rdwqhkb2pj";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ qtbase qttools seafile-shared ]
    ++ optional withShibboleth qtwebengine;

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ]
    ++ optional withShibboleth "-DBUILD_SHIBBOLETH_SUPPORT=ON";

  qtWrapperArgs = [
    "--suffix PATH : ${stdenv.lib.makeBinPath [ ccnet seafile-shared ]}"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/haiwen/seafile-client;
    description = "Desktop client for Seafile, the Next-generation Open Source Cloud Storage";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
