{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  curl,
  libargon2,
  libevent,
  libsearpc,
  libuuid,
  libwebsockets,
  python3,
  sqlite,
  vala,
}:

stdenv.mkDerivation rec {
  pname = "seafile-shared";
  version = "9.0.13";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile";
    tag = "v${version}";
    sha256 = "sha256-QRmm9HqmW9ERoxnuw089yAVp4JMUTGTcl7Dq3yz7YFQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    vala
    pkg-config
    python3
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    curl
    libargon2
    libevent
    libsearpc
    libuuid
    libwebsockets
    sqlite
  ];

  configureFlags = [
    "--disable-server"
    "--with-python3"
  ];

  pythonPath = with python3.pkgs; [
    future
    pysearpc
  ];

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    homepage = "https://github.com/haiwen/seafile";
    description = "Shared components of Seafile: seafile-daemon, libseafile, libseafile python bindings, manuals, and icons";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      greizgh
      schmittlauch
    ];
  };
}
