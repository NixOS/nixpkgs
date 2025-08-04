{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  qttools,
  libuuid,
  seafile-shared,
  jansson,
  libsearpc,
  withShibboleth ? true,
  qtwebengine,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "seafile-client";
  version = "9.0.12";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-client";
    rev = "v${version}";
    sha256 = "sha256-9ng8TsT211jAt2Vhv8fEIQGCtbQ6LQ6pCVFToVaK8LY=";
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
  ]
  ++ lib.optional withShibboleth qtwebengine;

  cmakeFlags = lib.optional withShibboleth "-DBUILD_SHIBBOLETH_SUPPORT=ON";

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ seafile-shared ]}"
  ];

  meta = {
    homepage = "https://github.com/haiwen/seafile-client";
    description = "Desktop client for Seafile, the Next-generation Open Source Cloud Storage";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      schmittlauch
    ];
    mainProgram = "seafile-applet";
  };
}
