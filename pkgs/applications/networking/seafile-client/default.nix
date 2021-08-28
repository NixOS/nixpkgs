{ mkDerivation, lib, fetchFromGitHub, pkg-config, cmake, qtbase, qttools
, seafile-shared, jansson, libsearpc
, withShibboleth ? true, qtwebengine }:

mkDerivation rec {
  pname = "seafile-client";
  version = "8.0.3";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-client";
    rev = "v${version}";
    sha256 = "cG3OSqRhYnxlzfauQia6pM/1gu+iE5mtHTGk3kGMFH0=";
  };

  nativeBuildInputs = [ pkg-config cmake ];
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
    maintainers = with maintainers; [ eduardosm ];
  };
}
