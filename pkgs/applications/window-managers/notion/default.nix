{ stdenv, fetchFromGitHub, pkgconfig
, lua, gettext, which, groff, xmessage, xterm
, readline, fontconfig, libX11, libXext, libSM
, libXinerama, libXrandr, libXft
, xlibsWrapper, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "notion";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "raboof";
    repo = pname;
    rev = version;
    sha256 = "0rqfvwkj0j862hf6i4wsmb6185xibsskfj9kwy896qcpcg8w4kk7";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper groff ];
  buildInputs = [ lua gettext which readline fontconfig libX11 libXext libSM
                  libXinerama libXrandr libXft xlibsWrapper ];

  buildFlags = [ "LUA_DIR=${lua}" "X11_PREFIX=/no-such-path" ];

  makeFlags = [ "NOTION_RELEASE=${version}" "PREFIX=\${out}" ];

  postInstall = ''
    wrapProgram $out/bin/notion \
      --prefix PATH ":" "${xmessage}/bin:${xterm}/bin" \
  '';

  meta = with stdenv.lib; {
    description = "Tiling tabbed window manager";
    homepage = "https://notionwm.net";
    license   = licenses.lgpl21;
    maintainers = with maintainers; [ jfb AndersonTorres raboof ];
    platforms = platforms.linux;
  };
}
