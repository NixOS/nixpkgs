{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  ncurses,
  libnl,
}:

stdenv.mkDerivation rec {
  pname = "horst";
  version = "5.1";

  src = fetchFromGitHub {
    owner = "br101";
    repo = "horst";
    rev = "v${version}";
    sha256 = "140pyv6rlsh4c745w4b59pz3hrarr39qq3mz9z1lsd3avc12nx1a";
  };

  patches = [
    # Fix pending upstream inclusion for ncurses-6.3:
    #  https://github.com/br101/horst/pull/110
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/br101/horst/commit/c9e9b6cc1f97edb9c53f3a67b43f3588f3ac6ea7.patch";
      sha256 = "15pahbnql44d5zzxmkd5ky8bl3c3hh3lh5190wynd90jrrhf1a26";
      # collides for context change, well apply this part in postPatch
      excludes = [ "display-main.c" ];
    })
  ];
  postPatch = ''
    # Apply second part of ncurses-6.3.patch:
    substituteInPlace display-main.c --replace 'wprintw(dump_win, str);' 'wprintw(dump_win, "%s", str);'
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    ncurses
    libnl
  ];

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  meta = with lib; {
    description = "Small and lightweight IEEE802.11 wireless LAN analyzer with a text interface";
    homepage = "https://github.com/br101/horst";
    maintainers = [ maintainers.fpletz ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "horst";
  };
}
