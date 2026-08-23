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

stdenv.mkDerivation (finalAttrs: {
  pname = "seafile-shared";
  version = "9.0.20";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PBoZDhY7GN8UuYUSXBCPZyBHBtlNcYK+0yS/rl66v9I=";
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
})
