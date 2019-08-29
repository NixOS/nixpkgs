{ stdenv, fetchurl, pkgconfig, glib, libX11, libXext, libXinerama }:

stdenv.mkDerivation rec {
  name = "herbstluftwm-0.7.2";

  src = fetchurl {
    url = "https://herbstluftwm.org/tarballs/${name}.tar.gz";
    sha256 = "1kc18aj9j3nfz6fj4qxg9s3gg4jvn6kzi3ii24hfm0vqdpy17xnz";
  };

  patchPhase = ''
    substituteInPlace config.mk \
      --replace "/usr/local" "$out" \
      --replace "/etc" "$out/etc" \
      --replace "/zsh/functions/Completion/X" "/zsh/site-functions" \
      --replace "/usr/share" "\$(PREFIX)/share"
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libX11 libXext libXinerama ];

  meta = {
    description = "A manual tiling window manager for X";
    homepage = http://herbstluftwm.org/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
