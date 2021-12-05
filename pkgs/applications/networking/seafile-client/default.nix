{ mkDerivation, lib, fetchFromGitHub, pkg-config, cmake, qtbase, qttools
, seafile-shared, jansson, libsearpc, withShibboleth ? true, qtwebengine }:

mkDerivation rec {
  pname = "seafile-client";
  version = "8.0.5";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-client";
    rev = "v${version}";
    sha256 = "1p9wkvnr3km829gy84b1w1pv72pany5vr3r7ydz1c0aqrp0snfhx";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ qtbase qttools seafile-shared jansson libsearpc ]
    ++ lib.optional withShibboleth qtwebengine;

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ]
    ++ lib.optional withShibboleth "-DBUILD_SHIBBOLETH_SUPPORT=ON";

  qtWrapperArgs = [ "--suffix PATH : ${lib.makeBinPath [ seafile-shared ]}" ];

  meta = with lib; {
    homepage = "https://github.com/haiwen/seafile-client";
    description =
      "Desktop client for Seafile, the Next-generation Open Source Cloud Storage";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ schmittlauch greizgh ];
  };
}
