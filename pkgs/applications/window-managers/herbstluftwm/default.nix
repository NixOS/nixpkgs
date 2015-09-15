{ stdenv, fetchurl, pkgconfig, glib, libX11, libXext, libXinerama }:

stdenv.mkDerivation rec {
  name = "herbstluftwm-0.6.2";

  src = fetchurl {
    url = "http://herbstluftwm.org/tarballs/${name}.tar.gz";
    sha256 = "1b7h2zi0i9j17k1z62qw5zq7j9i8gv33pmcxnfiilzzfg8wmr7x8";
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
    homepage = "http://herbstluftwm.org/";
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
  };
}
