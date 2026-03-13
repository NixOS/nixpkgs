{
  stdenv,
  lib,
  fetchzip,
  pkg-config,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpff";
  version = "20231205";

  src = fetchzip {
    url = "https://github.com/libyal/libpff/releases/download/${finalAttrs.version}/libpff-alpha-${finalAttrs.version}.tar.gz";
    hash = "sha256-VrdfZRC2iwTfv3YrObQvIH9QZPTi9pUQoAyUcBVJyes=";
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
