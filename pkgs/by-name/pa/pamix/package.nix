{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  cmake,
  libpulseaudio,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "pamix";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "patroclos";
    repo = "pamix";
    rev = version;
    sha256 = "1d44ggnwkf2gff62959pj45v3a2k091q8v154wc5pmzamam458wp";
  };

  patches = [
    # ncurses-6.3 support, included in next release
    (fetchpatch {
      name = "ncurses-6.3-p1.patch";
      url = "https://github.com/patroclos/PAmix/commit/3400b9c048706c572373e4617b4d5fcdb8dd2505.patch";
      sha256 = "0rw56a844pz876ad9p8hfvn2fkd5rh29gpp47h55g08spf0vwb2z";
    })
    (fetchpatch {
      name = "ncurses-6.3-p2.patch";
      url = "https://github.com/patroclos/PAmix/commit/5ef67fc5ef6fc0dc0b48ff07ba48093881561d9c.patch";
      sha256 = "0f8shpdv2swxdz04bkqgmkvl6c17r5mn4slzr7xd6pvw8hh51p4h";
    })
  ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace "/etc" "$out/etc/xdg"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libpulseaudio
    ncurses
  ];

  meta = with lib; {
    description = "Pulseaudio terminal mixer";
    homepage = "https://github.com/patroclos/PAmix";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
    mainProgram = "pamix";
  };
}
