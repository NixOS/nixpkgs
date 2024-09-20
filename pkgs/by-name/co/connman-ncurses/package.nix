{ lib, stdenv, fetchpatch, fetchFromGitHub, autoreconfHook, pkg-config, dbus, json_c, ncurses, connman }:

stdenv.mkDerivation {
  pname = "connman-ncurses";
  version = "2015-07-21";

  src = fetchFromGitHub {
    owner = "eurogiciel-oss";
    repo = "connman-json-client";
    rev = "3c34b2ee62d2e188090d20e7ed2fd94bab9c47f2";
    hash = "sha256-4aZoajVTYKp1CLyVgQ7Z/4Jy6GzBv4leQGQ7cw7IYaA=";
  };

  patches = [
    # Fix build with json-c 0.14
    (fetchpatch {
      url = "https://github.com/void-linux/void-packages/raw/5830ce60e922b7dced8157ededda8c995adb3bb9/srcpkgs/connman-ncurses/patches/lowercase-boolean.patch";
      extraPrefix = "";
      hash = "sha256-uK83DeRyXS2Y0ZZpTYvYNh/1ZM2QQ7QpajiBztaEuSM=";
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
    mainProgram = "connman_ncurses";
    homepage = "https://github.com/eurogiciel-oss/connman-json-client";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
