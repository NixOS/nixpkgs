{ stdenv, fetchFromGitHub, fetchpatch, qt, makeWrapper }:

stdenv.mkDerivation rec {
  name = "qtchan-${version}";
  version = "0.100";

  src = fetchFromGitHub {
    owner  = "siavash119";
    repo   = "qtchan";
    rev    = "v${version}";
    sha256 = "0n94jd6b1y8v6x5lkinr9rzm4bjg9xh9m7zj3j73pgq829gpmj3a";
  };

  patches = [
    (fetchpatch {
      url = https://github.com/siavash119/qtchan/commit/718abeee5cf4aca8c99b35b26f43909362a29ee6.patch;
      sha256 = "11b72l5njvfsyapd479hp4yfvwwb1mhq3f077hwgg0waz5l7n00z";
    })
  ];

  enableParallelBuilding = true;
  nativeBuildInputs = [ qt.qmake makeWrapper ];
  buildInputs = [ qt.qtbase ];

  qmakeFlags = [ "CONFIG-=app_bundle" ];

  installPhase = ''
    mkdir -p $out/bin
    cp qtchan $out/bin
  '';

  preFixup = ''
    wrapProgram $out/bin/qtchan \
      --suffix QT_PLUGIN_PATH : ${qt.qtbase.bin}/${qt.qtbase.qtPluginPrefix}
  '';

  meta = with stdenv.lib; {
    description = "4chan browser in qt5";
    homepage    = "https://github.com/siavash119/qtchan";
    license     = licenses.mit;
    maintainers = with maintainers; [ chiiruno ];
    platforms   = platforms.unix;
  };
}
