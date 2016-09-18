{
  enableXft ? true, libXft ? null,
  patches ? [],
  stdenv, fetchFromGitHub,
  lua, gettext, mandoc,
  pkgconfig, which,
  xlibsWrapper, libXinerama, libXrandr, libX11
}:

assert enableXft -> libXft != null;

let
  pname = "notion";
  version = "3-2015061300";
  sha256 = "1n7d6w06vmxsxyr6dcianm5czp3drr5vpp567458l4rxqd9935xn";
  inherit patches;
in
stdenv.mkDerivation {
  name = "${pname}-${version}";
  meta = with stdenv.lib; {
    description = "Tiling tabbed window manager, follow-on to the ion window manager";
    homepage = http://notion.sourceforge.net;
    platforms = platforms.linux;
    license   = licenses.notion_lgpl;
    maintainers = with maintainers; [ jfb ];
  };
  src = fetchFromGitHub {
    owner = "raboof";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "1n7d6w06vmxsxyr6dcianm5czp3drr5vpp567458l4rxqd9935xn";
  };

  patches = patches ++ stdenv.lib.optional enableXft ./notion-xft_nixos.diff;
  postPatch = ''
    substituteInPlace system-autodetect.mk \
      --replace '#PRELOAD_MODULES=1' 'PRELOAD_MODULES=1'
    substituteInPlace man/Makefile \
      --replace "nroff -man -Tlatin1"  "${mandoc}/bin/mandoc -T man"
  '';
  buildInputs = [xlibsWrapper lua gettext mandoc pkgconfig which libXinerama libXrandr libX11] ++ stdenv.lib.optional enableXft libXft;

  buildFlags = "LUA_DIR=${lua} X11_PREFIX=/no-such-path PREFIX=\${out}";
  installFlags = "PREFIX=\${out}";
}
