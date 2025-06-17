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
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "dbus-cxx";
    repo = "dbus-cxx";
    tag = finalAttrs.version;
    hash = "sha256-jhooz1RsDn8XeLdaAcvlIdAKhLbTFnlwa7/YVYSR+7Y=";
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
    description = "Object-oriented interface to DBus";
    license = with lib.licenses; [
      lgpl3Plus
      # or
      bsd3
    ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.fredeb ];
  };
})
