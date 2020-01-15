{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake, qtbase, qttools
, seafile-shared, ccnet, jansson, libsearpc
, withShibboleth ? true, qtwebengine }:

stdenv.mkDerivation rec {
  pname = "seafile-client";
  version = "7.0.5";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-client";
    rev = "v${version}";
    sha256 = "08ysmhvdpyzq2s16i3fvii252fzjrxly3da74x8y6wbyy8yywmjy";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ qtbase qttools seafile-shared jansson libsearpc ]
    ++ lib.optional withShibboleth qtwebengine;

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ]
    ++ lib.optional withShibboleth "-DBUILD_SHIBBOLETH_SUPPORT=ON";

  qtWrapperArgs = [
    "--suffix PATH : ${stdenv.lib.makeBinPath [ ccnet seafile-shared ]}"
  ];

  meta = with lib; {
    homepage = "https://github.com/haiwen/seafile-client";
    description = "Desktop client for Seafile, the Next-generation Open Source Cloud Storage";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
