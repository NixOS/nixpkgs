{
  stdenv,
  lib,
  fetchzip,
  pkg-config,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpff";
  version = "20260926";

  # fetchFromGitHub is not used because they're pre-processing the code before
  # pushing the zip to releases (something to do with Microsoft vcprojs).
  # If we don't do fetchzip, it won't compile.
  src = fetchzip {
    url = "https://github.com/libyal/libpff/releases/download/${finalAttrs.version}/libpff-alpha-${finalAttrs.version}.tar.gz";
    hash = "sha256-4lddoTUBmGXBFx1fvuki0IYxpal+pR6JC808ctFcckw=";
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
    changelog = "https://github.com/libyal/libpff/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ hacker1024 ];
  };
})
