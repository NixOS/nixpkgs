{ mkDerivation, lib, fetchsvn, qmake, qtbase, qttools, bison, flex }:

mkDerivation rec {
  pname = "QtSpim";
  version = "722";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/spimsimulator/code";
    rev = version;
    sha256 = "1hfz41ra93pdd2pri5hibl63sg9yyk12a8nhdkmgj7h9bwgqxw6b";
  };

  sourceRoot = "code-r${version}/QtSpim";

  nativeBuildInputs = [ bison flex qmake ];

  buildInputs = [ qtbase qttools ];

  # Remove build artifacts from the repo
  preConfigure = ''
    rm parser_yacc.h
    rm parser_yacc.cpp
    rm scanner_lex.cpp

    rm help/qtspim.qhc
  '';

  # Fix bug in a generated Makefile
  postConfigure = ''
    substituteInPlace Makefile --replace '$(MOVE) help/qtspim.qhc help/qtspim.qhc;' ""
  '';

  # Fix documentation path
  postPatch = ''
    substituteInPlace menu.cpp --replace "/usr/lib/qtspim/help/qtspim.qhc" "$out/share/qtspim/help/qtspim.qhc"
    substituteInPlace menu.cpp --replace "/usr/lib/qtspim/bin/assistant" "${qttools.dev}/bin/assistant"

    substituteInPlace ../Setup/qtspim_debian_deployment/qtspim.desktop \
      --replace "/usr/lib/qtspim/qtspim.png" "$out/share/qtspim/qtspim.png" \
      --replace "/usr/bin/qtspim" "$out/bin/qtspim"
  '';

  buildPhase = ''
    export QT_PLUGIN_PATH="${qtbase.bin}/${qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM_PLUGIN_PATH="${qtbase.bin}/${qtbase.qtPluginPrefix}/platforms"
    make
  '';

  installPhase = ''
    install -Dm0755 QtSpim $out/bin/qtspim

    install -D ../Documentation/qtspim.man $out/share/man/man1/qtspim.1
    gzip -f --best $out/share/man/man1/qtspim.1

    install -Dm0644 help/qtspim.qch $out/share/qtspim/help/qtspim.qch
    install -Dm0644 help/qtspim.qhc $out/share/qtspim/help/qtspim.qhc

    install -Dm0644 ../Setup/qtspim_debian_deployment/qtspim.desktop $out/share/applications/qtspim.desktop
    install -Dm0644 ../Setup/qtspim_debian_deployment/copyright $out/share/licenses/qtspim/copyright
    install -Dm0644 ../Setup/NewIcon48x48.png $out/share/qtspim/qtspim.png

    install -Dm0644 ../helloworld.s $out/share/qtspim/helloworld.s
  '';

  meta = with lib; {
    description = "SPIM MIPS simulator";
    longDescription = ''
      SPIM is a self-contained simulator that runs MIPS32 assembly language programs.
      SPIM also provides a simple debugger and minimal set of operating system services.
    '';

    homepage = "https://sourceforge.net/projects/spimsimulator";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aske ];
  };
}
