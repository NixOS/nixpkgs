{ stdenv, fetchFromGitHub, pkgconfig, cmake, qtbase, qttools
, seafile-shared, ccnet, makeWrapper
, withShibboleth ? true, qtwebengine }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "6.2.4";
  name = "seafile-client-${version}";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-client";
    rev = "v${version}";
    sha256 = "0z5li1d7ipsm1mp0lk6mls220v4vlmsqm8ym8kxlkinqbmkky0hz";
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
    maintainers = with maintainers; [ dotlambda ];
  };
}
