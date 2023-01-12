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
  version = "0.7.0";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "seatd";
    rev = version;
    sha256 = "sha256-m8xoL90GI822FTgCXuVr3EejLAMUStkPKVoV7w8ayIE=";
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
    platforms   = with platforms; freebsd ++ linux ++ netbsd;
    maintainers = with maintainers; [ emantor ];
  };
}
