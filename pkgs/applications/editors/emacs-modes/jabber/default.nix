{ stdenv, fetchurl, emacs }:
stdenv.mkDerivation rec {
  pname  = "emacs-jabber";
  version = "0.8.0";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.bz2";
    sha256 = "75e3b7853de4783b8ab8270dcbe6a1e4f576224f77f7463116532e11c6498c26";
  };
  buildInputs = [ emacs ];
  meta = {
    description = "A Jabber client for Emacs";
    longDescription = ''
      jabber.el is a Jabber client for Emacs. It may seem strange to have a
      chat client in an editor, but consider that chatting is, after all, just
      a special case of text editing.
    '';
    homepage = http://emacs-jabber.sourceforge.net/;
    license = [ "GPLv2+" ];
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
