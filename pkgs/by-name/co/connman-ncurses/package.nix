{ lib, stdenv, fetchpatch, fetchFromGitHub, autoreconfHook, pkg-config, dbus, json_c, ncurses, connman }:

stdenv.mkDerivation {
  pname = "connman-ncurses";
  version = "2015-07-21";

  src = fetchFromGitHub {
    owner = "eurogiciel-oss";
    repo = "connman-json-client";
    rev = "3c34b2ee62d2e188090d20e7ed2fd94bab9c47f2";
    sha256 = "1831r0776fv481g8kgy1dkl750pzv47835dw11sslq2k6mm6i9p1";
  };

  patches = [
    # Fix build with json-c 0.14
    (fetchpatch {
      url = "https://github.com/void-linux/void-packages/raw/5830ce60e922b7dced8157ededda8c995adb3bb9/srcpkgs/connman-ncurses/patches/lowercase-boolean.patch";
      extraPrefix = "";
      sha256 = "uK83DeRyXS2Y0ZZpTYvYNh/1ZM2QQ7QpajiBztaEuSM=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ dbus ncurses json_c connman ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  installPhase = ''
    mkdir -p "$out/bin"
    cp -va connman_ncurses "$out/bin/"
  '';

  meta = with lib; {
    description = "Simple ncurses UI for connman";
    homepage = "https://github.com/eurogiciel-oss/connman-json-client";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
