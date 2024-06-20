{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, qtbase
, qttools
, libuuid
, seafile-shared
, jansson
, libsearpc
, withShibboleth ? true
, qtwebengine
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "seafile-client";
  version = "9.0.6";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-client";
    rev = "v${version}";
    sha256 = "sha256-JjicVgDqiuIuVn7swbVekqQ+3Ly64Nd7qKu5UymTEYE=";
  };

  nativeBuildInputs = [
    libuuid
    pkg-config
    cmake
    wrapQtAppsHook
    qttools
  ];

  buildInputs = [
    seafile-shared
    jansson
    libsearpc
  ] ++ lib.optional withShibboleth qtwebengine;

  cmakeFlags = lib.optional withShibboleth "-DBUILD_SHIBBOLETH_SUPPORT=ON";

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ seafile-shared ]}"
  ];

  meta = with lib; {
    homepage = "https://github.com/haiwen/seafile-client";
    description = "Desktop client for Seafile, the Next-generation Open Source Cloud Storage";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ schmittlauch greizgh ];
    mainProgram = "seafile-applet";
  };
}
