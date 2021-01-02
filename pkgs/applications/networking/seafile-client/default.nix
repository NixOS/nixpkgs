{ mkDerivation, lib, fetchFromGitHub, pkgconfig, cmake, qtbase, qttools
, seafile-shared, jansson, libsearpc
, withShibboleth ? true, qtwebengine }:

mkDerivation rec {
  pname = "seafile-client";
  version = "7.0.10";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-client";
    rev = "v${version}";
    sha256 = "082v1qbysrqb7m0lk56fpx8n403fjxbvbj0svm4mkjl6mzs2cv22";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ qtbase qttools seafile-shared jansson libsearpc ]
    ++ lib.optional withShibboleth qtwebengine;

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ]
    ++ lib.optional withShibboleth "-DBUILD_SHIBBOLETH_SUPPORT=ON";

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ seafile-shared ]}"
  ];

  meta = with lib; {
    homepage = "https://github.com/haiwen/seafile-client";
    description = "Desktop client for Seafile, the Next-generation Open Source Cloud Storage";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
