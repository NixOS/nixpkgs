{ lib
, stdenv
, vdr
, fetchFromGitHub
, graphicsmagick
, pcre
, xorgserver
, ffmpeg
, libiconv
, boost
, libgcrypt
, perl
, util-linux
, groff
, libva
, xorg
, ncurses
, callPackage
}:
stdenv.mkDerivation rec {
  pname = "vdr-markad";
  version = "3.6.0";

  src = fetchFromGitHub {
    repo = "vdr-plugin-markad";
    owner = "kfb77";
    sha256 = "sha256-O958GNQI6Z+m4sIJfGQzLaCrzyrdpn+ZY8COx7RoUZs=";
    rev = "V${version}";
  };

  buildInputs = [ vdr ffmpeg ];

  postPatch = ''
    substituteInPlace command/Makefile --replace '/usr' ""

    substituteInPlace plugin/markad.cpp \
      --replace "/usr/bin" "$out/bin" \
      --replace "/var/lib/markad" "$out/var/lib/markad"

    substituteInPlace command/markad-standalone.cpp \
      --replace "/var/lib/markad" "$out/var/lib/markad"
  '';

  buildFlags = [
    "DESTDIR=$(out)"
    "VDRDIR=${vdr.dev}/lib/pkgconfig"
  ];

  installFlags = buildFlags;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Plugin for VDR that marks advertisements";
    mainProgram = "markad";
    maintainers = [ maintainers.ck3d ];
    license = licenses.gpl2;
    inherit (vdr.meta) platforms;
  };

}
