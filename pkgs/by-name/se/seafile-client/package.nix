{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  pkg-config,
  cmake,
  qt6,
  libuuid,
  seafile-shared,
  jansson,
  libsearpc,
  withShibboleth ? true,
}:

stdenv.mkDerivation rec {
  pname = "seafile-client";
  version = "9.0.15";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-client";
    tag = "v${version}";
    hash = "sha256-BV1+9/+ryZB1BQyRJ5JaIU6bbOi4h8vt+V+FQIfUJp8=";
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
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    qt6.qt5compat
    seafile-shared
    jansson
    libsearpc
  ]
  ++ lib.optional withShibboleth qt6.qtwebengine;

  cmakeFlags = lib.optional withShibboleth "-DBUILD_SHIBBOLETH_SUPPORT=ON";

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ seafile-shared ]}"
  ];

  meta = with lib; {
    homepage = "https://github.com/haiwen/seafile-client";
    changelog = "https://github.com/haiwen/seafile-client/releases/tag/${src.tag}";
    description = "Desktop client for Seafile, the Next-generation Open Source Cloud Storage";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      schmittlauch
    ];
    mainProgram = "seafile-applet";
  };
}
