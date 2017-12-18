{ lib, stdenv, fetchFromGitHub, pkgconfig, makeWrapper
, swc, libxkbcommon
, wld, wayland, pixman, fontconfig
, dmenu-wayland, st-wayland
}:

stdenv.mkDerivation rec {
  name = "velox-${version}";
  version = "git-2017-07-04";

  src = fetchFromGitHub {
    owner = "michaelforney";
    repo = "velox";
    rev = "0b1d3d62861653d92d0a1056855a84fcef661bc0";
    sha256 = "0p5ra5p5w21wl696rmv0vdnl7jnri5iwnxfs6nl6miwydhq2dmci";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs = [ swc libxkbcommon wld wayland pixman fontconfig ];

  propagatedUserEnvPkgs = [ swc ];

  makeFlags = "PREFIX=$(out)";
  preBuild = ''
    substituteInPlace config.c \
      --replace /etc/velox.conf $out/etc/velox.conf
  '';
  installPhase = ''
    PREFIX=$out make install
    mkdir -p $out/etc
    cp velox.conf.sample $out/etc/velox.conf
  '';
  postFixup = ''
    wrapProgram $out/bin/velox \
      --prefix PATH : "${stdenv.lib.makeBinPath [ dmenu-wayland st-wayland ]}"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "velox window manager";
    homepage    = "https://github.com/michaelforney/velox";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
