{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  libX11,
  cairo,
  lv2,
  ncurses,
  fluidsynth,
}:

stdenv.mkDerivation rec {
  pname = "Fluida.lv2";
  version = "0.9.5";

  xputtysrc = fetchFromGitHub {
    owner = "brummer10";
    repo = "libxputty";
    rev = "1627a221781d6e7f5a1ab7d4180c41debaed9094";
    sha256 = "sha256-0nBfY46GWPW1b/9/Y5fBexaQohyjomI0ZEjOVsZMo4c=";
  };

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "Fluida.lv2";
    rev = "v${version}";
    sha256 = "sha256-JpchCbN6XIao2ykkrV5QiCBiyQ/uj0BmSZwNLmy2+bU=";
  };

  nativeBuildInputs = [
    ncurses
  ];

  buildInputs = [
    cairo
    libX11
    lv2
    pkg-config
    fluidsynth
  ];

  preBuild = ''
    cp -r ${xputtysrc}/* ./libxputty/
    chmod -R u+w .
    ls -lR .

    # see Fluida/Makefile: this wants to install in ~/.lv2
    # so we need to set the HOME variable to a writable location:
    mkdir $(pwd)/home
    export HOME=$(pwd)/home
    export lv2dir=$(pwd)/home/.lv2
  '';

  postInstall = ''
    # copy the lv2 files to the output directory:
    mkdir -p $out/lib/lv2
    cp -r $lv2dir/* $out/lib/lv2/
  '';

  meta = {
    description = "Fluidsynth as LV2 plugin";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [
      joostn
    ];
    platforms = [ "x86_64-linux" ];
    homepage = "https://github.com/brummer10/Fluida.lv2";
  };
}
