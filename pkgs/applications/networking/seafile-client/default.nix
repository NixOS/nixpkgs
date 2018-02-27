{ stdenv, fetchurl, writeScript, pkgconfig, cmake, qtbase, qttools
, seafile-shared, ccnet, makeWrapper
, withShibboleth ? true, qtwebengine }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "6.1.5";
  name = "seafile-client-${version}";

  src = fetchurl {
    url = "https://github.com/haiwen/seafile-client/archive/v${version}.tar.gz";
    sha256 = "09m1k99pb8vj37zfr8a0j5xyghyvxindmdpgxvvxh589q4ngfsx8";
  };

  nativeBuildInputs = [ pkgconfig cmake makeWrapper ];
  buildInputs = [ qtbase qttools seafile-shared ]
    ++ optional withShibboleth qtwebengine;

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ]
    ++ optional withShibboleth "-DBUILD_SHIBBOLETH_SUPPORT=ON";

  postInstall = ''
    wrapProgram $out/bin/seafile-applet \
      --suffix PATH : ${stdenv.lib.makeBinPath [ ccnet seafile-shared ]}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/haiwen/seafile-client;
    description = "Desktop client for Seafile, the Next-generation Open Source Cloud Storage";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.calrama ];
  };
}
