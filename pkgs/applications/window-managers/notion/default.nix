{
  enableXft ? true, libXft ? null, patches ? [], stdenv, lua, gettext, pkgconfig, xlibsWrapper, libXinerama, libXrandr, libX11,
  xterm, xmessage, makeWrapper, fetchFromGitHub, mandoc, which
}:

assert enableXft -> libXft != null;

let
  pname = "notion";
  version = "3-2017050501";
  inherit patches;
in
stdenv.mkDerivation {
  name = "${pname}-${version}";
  meta = with stdenv.lib; {
    description = "Tiling tabbed window manager, follow-on to the ion window manager";
    homepage = http://notion.sourceforge.net;
    platforms = platforms.linux;
    license   = licenses.notion_lgpl;
    maintainers = with maintainers; [jfb];
  };
  src = fetchFromGitHub {
    owner = "raboof";
    repo = pname;
    rev = version;
    sha256 = "1wq5ylpsw5lkbm3c2bzmx2ajlngwib30adxlqbvq4bgkaf9zjh65";
  };

  patches = patches;
  postPatch = ''
    substituteInPlace system-autodetect.mk --replace '#PRELOAD_MODULES=1' 'PRELOAD_MODULES=1'
    substituteInPlace man/Makefile --replace "nroff -man -Tlatin1" "${mandoc}/bin/mandoc -T man"
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [makeWrapper xlibsWrapper lua gettext mandoc which libXinerama libXrandr libX11 ] ++ stdenv.lib.optional enableXft libXft;

  buildFlags = [ "LUA_DIR=${lua}" "X11_PREFIX=/no-such-path" "PREFIX=\${out}" ];
  installFlags = [ "PREFIX=\${out}" ];

  postInstall = ''
    wrapProgram $out/bin/notion \
      --prefix PATH ":" "${xmessage}/bin:${xterm}/bin" \
  '';
}
