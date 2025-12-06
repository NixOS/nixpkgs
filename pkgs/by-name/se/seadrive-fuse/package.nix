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
  fuse,
}:

stdenv.mkDerivation rec {
  pname = "seadrive-fuse";
  version = "3.0.18";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seadrive-fuse";
    rev = "v${version}";
    hash = "sha256-oMi297ORIKdJhuYOvazJ+oSVCwRAqvjy0pc+lyBq5oQ=";
  };

  nativeBuildInputs = [
    libwebsockets
    autoreconfHook
    vala
    fuse
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

  meta = {
    homepage = "https://github.com/haiwen/seadrive-fuse";
    description = "SeaDrive daemon with FUSE interface ";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      schmittlauch
    ];
  };
}
