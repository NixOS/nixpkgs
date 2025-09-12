{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  pkg-config,
  cmake,
  qttools,
  qt5compat,
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
  version = "9.0.14";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-client";
    rev = "v${version}";
    hash = "sha256-ZMhU0uXAC3tH1e3ktiHhC5YCDwFOnILretPgjYYa9DQ=";
  };

  patches = [
    # https://github.com/NixOS/nixpkgs/issues/442063
    (fetchpatch {
      name = "fix_build_with_QT6.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix_build_with_QT6.diff?h=seafile-client&id=8bbd6e5017f03dbb368603b4313738b0d783ca2a";
      hash = "sha256-N1fepqjTm/M17+TgwNTUecP/wGVlBuZEtTezFgJEeVM=";
    })
  ];

  nativeBuildInputs = [
    libuuid
    pkg-config
    cmake
    wrapQtAppsHook
    qttools
  ];

  buildInputs = [
    qt5compat
    seafile-shared
    jansson
    libsearpc
  ]
  ++ lib.optional withShibboleth qtwebengine;

  cmakeFlags = lib.optional withShibboleth "-DBUILD_SHIBBOLETH_SUPPORT=ON";

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ seafile-shared ]}"
  ];

  meta = with lib; {
    homepage = "https://github.com/haiwen/seafile-client";
    description = "Desktop client for Seafile, the Next-generation Open Source Cloud Storage";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      schmittlauch
    ];
    mainProgram = "seafile-applet";
  };
}
