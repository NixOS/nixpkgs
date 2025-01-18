{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  python3,
  glib,
  jansson,
}:

stdenv.mkDerivation rec {
  version = "3.3-20241031";
  commit = "d00c062d76d86b76c8c179bfb4babc9e2200b3f1";
  pname = "libsearpc";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "libsearpc";
    rev = commit;
    sha256 = "sha256-Ze1dOEFUIA16OlqkyDjQw6c6JcDECjYsdCm5um0kG/c=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];

  propagatedBuildInputs = [
    glib
    jansson
  ];

  meta = with lib; {
    homepage = "https://github.com/haiwen/libsearpc";
    description = "Simple and easy-to-use C language RPC framework based on GObject System";
    mainProgram = "searpc-codegen.py";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ greizgh ];
  };
}
