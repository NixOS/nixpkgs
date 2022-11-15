{ lib, stdenv, fetchFromGitHub, pkg-config
, lua, gettext, which, groff, xmessage, xterm
, readline, fontconfig, libX11, libXext, libSM
, libXinerama, libXrandr, libXft
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "notion";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "raboof";
    repo = pname;
    rev = version;
    sha256 = "14swd0yqci8lxn259fkd9w92bgyf4rmjwgvgyqp78wlfix6ai4mv";
  };

  nativeBuildInputs = [ pkg-config makeWrapper groff ];
  buildInputs = [ lua gettext which readline fontconfig libX11 libXext libSM
                  libXinerama libXrandr libXft ];

  buildFlags = [ "LUA_DIR=${lua}" "X11_PREFIX=/no-such-path" ];

  makeFlags = [ "NOTION_RELEASE=${version}" "PREFIX=\${out}" ];

  postInstall = ''
    wrapProgram $out/bin/notion \
      --prefix PATH ":" "${xmessage}/bin:${xterm}/bin" \
  '';

  meta = with lib; {
    description = "Tiling tabbed window manager";
    homepage = "https://notionwm.net";
    license   = licenses.lgpl21;
    maintainers = with maintainers; [ jfb AndersonTorres raboof ];
    platforms = platforms.linux;
  };
}
