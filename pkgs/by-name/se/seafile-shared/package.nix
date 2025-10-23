{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  curl,
  libargon2,
  libevent,
  libsearpc,
  libuuid,
  pkg-config,
  python3,
  sqlite,
  vala,
  libwebsockets,
}:

stdenv.mkDerivation rec {
  pname = "seafile-shared";
  version = "9.0.15";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile";
    rev = "v${version}";
    hash = "sha256-mWIOk8O3vlg7Sm/5ZQUB5nOgi8/pEczCGQ94p0km/GI=";
  };

  postPatch = ''
    substituteInPlace scripts/breakpad.py --replace-fail "from __future__ import print_function" ""
  '';

  nativeBuildInputs = [
    libwebsockets
    autoreconfHook
    vala
    pkg-config
    python3
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    libargon2
    libuuid
    sqlite
    libsearpc
    libevent
    curl
  ];

  configureFlags = [
    "--disable-server"
    "--with-python3"
  ];

  pythonPath = with python3.pkgs; [
    pysearpc
  ];

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = {
    homepage = "https://github.com/haiwen/seafile";
    description = "Shared components of Seafile: seafile-daemon, libseafile, libseafile python bindings, manuals, and icons";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      schmittlauch
    ];
  };
}
