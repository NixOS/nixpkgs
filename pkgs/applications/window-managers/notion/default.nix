{
  enableXft ? true, libXft ? null, stdenv, lua, gettext, readline, pkgconfig, xlibsWrapper, libXinerama, libXrandr, libX11,
  xterm, xmessage, makeWrapper, fetchFromGitHub, mandoc, which, groff
}:

assert enableXft -> libXft != null;

stdenv.mkDerivation rec {
  name = "notion-unstable-2019-11-09";
  meta = with stdenv.lib; {
    description = "Tiling tabbed window manager";
    homepage = https://notionwm.net;
    platforms = platforms.linux;
    license   = licenses.lgpl21;
    maintainers = with maintainers; [jfb raboof];
  };
  src = fetchFromGitHub {
    owner = "raboof";
    repo = "notion";
    rev = "b1bce6786684ff25a929aaa7ca4ce1c9c5bce904";
    sha256 = "1kpqg7vnamhzpalx8ak3nc896sn146aqaljxaagl2szfqk9jzgdp";
  };

  nativeBuildInputs = [ pkgconfig groff ];
  buildInputs = [makeWrapper xlibsWrapper lua gettext mandoc which libXinerama libXrandr libX11 readline] ++ stdenv.lib.optional enableXft libXft;

  buildFlags = "LUA_DIR=${lua} X11_PREFIX=/no-such-path PREFIX=\${out}";
  installFlags = "PREFIX=\${out}";

  postInstall = ''
    wrapProgram $out/bin/notion \
      --prefix PATH ":" "${xmessage}/bin:${xterm}/bin" \
  '';
}
