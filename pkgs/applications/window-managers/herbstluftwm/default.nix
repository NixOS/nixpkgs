{ stdenv, fetchurl, pkgconfig, glib, libX11, libXext, libXinerama }:

stdenv.mkDerivation rec {
  name = "herbstluftwm-0.7.0";

  src = fetchurl {
    url = "http://herbstluftwm.org/tarballs/${name}.tar.gz";
    sha256 = "09xfs213vg1dpird61wik5bqb9yf8kh63ssy18ihf54inwqgqbvy";
  };

  patchPhase = ''
    substituteInPlace config.mk \
      --replace "/usr/local" "$out" \
      --replace "/etc" "$out/etc" \
      --replace "/zsh/functions/Completion/X" "/zsh/site-functions"
  '';

  buildInputs = [ pkgconfig glib libX11 libXext libXinerama ];

  meta = {
    description = "A manual tiling window manager for X";
    homepage = http://herbstluftwm.org/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
