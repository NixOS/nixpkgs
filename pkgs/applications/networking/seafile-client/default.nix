{ stdenv, fetchFromGitHub, pkgconfig, cmake, qtbase, qttools
, seafile-shared, ccnet, makeWrapper
, withShibboleth ? true, qtwebengine }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "6.2.7";
  name = "seafile-client-${version}";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-client";
    rev = "v${version}";
    sha256 = "16ikl6vkp9v16608bq2sfg48idn2p7ik3q8n6j866zxkmgdvkpsg";
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
