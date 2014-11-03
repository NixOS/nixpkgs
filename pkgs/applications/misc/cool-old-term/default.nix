{ stdenv, fetchFromGitHub, qt53 }:

stdenv.mkDerivation rec {
  version = "0.9";
  name = "cool-old-term-${version}";

  src = fetchFromGitHub {
    owner = "Swordifish90";
    repo = "cool-old-term";
    rev = "2494bc05228290545df8c59c05624a4b903e9068";
    sha256 = "8462f3eded7b2219acc143258544b0dfac32d81e10cac61ff14276d426704c93";
  };

  buildInputs = [ qt53 ];

  buildPhase = ''
    pushd ./konsole-qml-plugin
    qmake konsole-qml-plugin.pro PREFIX=$out
    make
    popd
  '';

  installPhase = ''
    pushd ./konsole-qml-plugin
    make install
    popd

    install -d $out/bin $out/lib/cool-old-term $out/share/cool-old-term
    cp -a ./imports $out/lib/cool-old-term/
    cp -a ./app     $out/share/cool-old-term/

    cat > $out/bin/cool-old-term <<EOF
    #!${stdenv.shell}
    ${qt53}/bin/qmlscene -I $out/lib/cool-old-term/imports $out/share/cool-old-term/app/main.qml
    EOF
    chmod a+x $out/bin/cool-old-term
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Terminal emulator which mimics the old cathode display";
    longDescription = ''
      cool-old-term is a terminal emulator which tries to mimic the look and
      feel of the old cathode tube screens. It has been designed to be
      eye-candy, customizable, and reasonably lightweight.
    '';
    homepage = "https://github.com/Swordifish90/cool-old-term";
    licenses = with stdenv.lib.licenses; [ gpl2 gpl3 ];
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ skeidel ];
  };
}
