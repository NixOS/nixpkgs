{ stdenv, fetchFromGitHub, pkgconfig
, lua, gettext, which, groff, xmessage, xterm
, readline, fontconfig, libX11, libXext, libSM
, libXinerama, libXrandr, libXft
, xlibsWrapper, makeWrapper
}:

stdenv.mkDerivation rec{
  pname = "notion";
  version = "3-2019050101";

  src = fetchFromGitHub {
    owner = "raboof";
    repo = pname;
    rev = version;
    sha256 = "09kvgqyw0gnj3jhz9gmwq81ak8qy32vyanx1hw79r6m181aysspz";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper groff ];
  buildInputs = [ lua gettext which readline fontconfig libX11 libXext libSM
                  libXinerama libXrandr libXft xlibsWrapper ];

  buildFlags = [ "CC=cc" "LUA_DIR=${lua}" "X11_PREFIX=/no-such-path" ];

  makeFlags = [ "PREFIX=\${out}" ];

  postInstall = ''
    wrapProgram $out/bin/notion \
      --prefix PATH ":" "${xmessage}/bin:${xterm}/bin" \
  '';

  meta = with stdenv.lib; {
    description = "Tiling tabbed window manager, follow-on to the Ion";
    homepage = "https://notionwm.net/";
    license   = licenses.lgpl21;
    maintainers = with maintainers; [ jfb AndersonTorres ];
    platforms = platforms.linux;
  };
}
