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
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "dbus-cxx";
    repo = "dbus-cxx";
    tag = finalAttrs.version;
    hash = "sha256-ug6oDycRi4JTBuqSFTMQCd2k2Q5oziXD16y98Nw6R44=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [ libsigcxx30 ];

  cmakeFlags = [
    "-GNinja"
  ];

  meta = {
    homepage = "https://github.com/dbus-cxx/dbus-cxx";
    description = "DBus-cxx provides an object-oriented interface to DBus";
    license = with lib.licenses; [
      lgpl3Plus
      # or
      bsd3
    ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.fredeb ];
  };
})
