{ fetchFromSourcehut
, lib
, meson
, ninja
, pkg-config
, scdoc
, stdenv
, systemdSupport ? stdenv.isLinux, systemd
}:

stdenv.mkDerivation rec {
  pname = "seatd";
  version = "0.6.4";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "seatd";
    rev = version;
    sha256 = "1k0wz68aqr9xgpyrfrsmrjn5b634qmm7fwv2d73w112hjmgvjxk5";
  };

  outputs = [ "bin" "out" "dev" "man" ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [ meson ninja pkg-config scdoc ];

  buildInputs = lib.optionals systemdSupport [ systemd ];

  mesonFlags = [
    "-Dlibseat-logind=${if systemdSupport then "systemd" else "disabled"}"
    "-Dlibseat-builtin=enabled"
    "-Dserver=enabled"
  ];

  meta = with lib; {
    description = "A universal seat management library";
    changelog   = "https://git.sr.ht/~kennylevinsen/seatd/refs/${version}";
    homepage    = "https://sr.ht/~kennylevinsen/seatd/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ emantor ];
  };
}
