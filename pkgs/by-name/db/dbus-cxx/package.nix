{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  ninja,
  pkg-config,
  libsigcxx30,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dbus-cxx";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "dbus-cxx";
    repo = "dbus-cxx";
    tag = finalAttrs.version;
    hash = "sha256-if/9XIsf3an5Sij91UIIyNB3vlFAcKrm6YT5Mk7NhB0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  cmakeFlags = [
    "-GNinja"
  ];

  buildInputs = [ libsigcxx30 ];

  meta = {
    homepage = "https://github.com/dbus-cxx/dbus-cxx";
    description = "DBus-cxx provides an object-oriented interface to DBus";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.fredeb ];
  };
})
