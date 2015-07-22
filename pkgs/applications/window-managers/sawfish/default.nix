{ stdenv, fetchgit, pkgconfig, which, autoreconfHook, rep-gtk, pango
, gdk_pixbuf, libXinerama, libXrandr, libXtst, imlib, gettext, texinfo
, makeWrapper
}:

with stdenv.lib;

stdenv.mkDerivation rec {

  name = "sawfish-${version}";
  version = "1.11.90";

  src = fetchgit {
    url = "https://github.com/SawfishWM/sawfish.git";
    rev = "b121f832571c9aebd228691c32604146e49f5e55";
    sha256 = "0y7rmjzp7ha5qj9q1dasw50gd6jiaxc0qsjbvyfzxvwssl3i9hsc";
  };

  buildInputs =
    [ pkgconfig which autoreconfHook rep-gtk pango gdk_pixbuf libXinerama
      libXrandr libXtst imlib gettext texinfo makeWrapper
    ];

  patchPhase = ''
    sed -e 's|REP_DL_LOAD_PATH=|REP_DL_LOAD_PATH=$(REP_DL_LOAD_PATH):|g' -i Makedefs.in
    sed -e 's|$(repexecdir)|$(libdir)/rep|g' -i src/Makefile.in
  '';

  postInstall = ''
    for i in $out/lib/sawfish/sawfish-menu $out/bin/sawfish-about  $out/bin/sawfish-client $out/bin/sawfish-config $out/bin/sawfish; do
      wrapProgram $i \
        --prefix REP_DL_LOAD_PATH "$out/lib/rep" \
	--set REP_LOAD_PATH "$out/share/sawfish/lisp"
    done
  '';

  meta = {
    description = "An extensible, Lisp-based window manager";
    longDescription = ''
      Sawfish is an extensible window manager using a Lisp-based scripting language.
      Its policy is very minimal compared to most window managers. Its aim is simply
      to manage windows in the most flexible and attractive manner possible.
      All high-level WM functions are implemented in Lisp for future extensibility
      or redefinition.
    '';
    homepage = http://sawfish.wikia.com;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
