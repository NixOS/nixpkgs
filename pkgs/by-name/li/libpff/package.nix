{
  stdenv,
  lib,
  fetchzip,
  pkg-config,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libpff";
  version = "20211114";

  src = fetchzip {
    url = "https://github.com/libyal/libpff/releases/download/${version}/libpff-alpha-${version}.tar.gz";
    sha256 = "sha256-UmGRBgi78nDSuuOXi/WmODojWU5AbQGKNQwLseoh714=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  outputs = [
    "bin"
    "dev"
    "out"
  ];

  meta = {
    description = "Library and tools to access the Personal Folder File (PFF) and the Offline Folder File (OFF) format";
    homepage = "https://github.com/libyal/libpff";
    downloadPage = "https://github.com/libyal/libpff/releases";
    changelog = "https://github.com/libyal/libpff/blob/${version}/ChangeLog";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ hacker1024 ];
  };
}
