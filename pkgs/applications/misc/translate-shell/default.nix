{ stdenv, fetchFromGitHub, curl, fribidi, mpv, less, rlwrap, gawk, bash, emacs, groff, ncurses, pandoc }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "translate-shell";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "soimort";
    repo = "translate-shell";
    rev = "v" + version;
    sha256 = "166zhic3k4z37vc8p1fnhc4xx7i7q0j30nr324frmp1mrnwrdib8";
  };

  phases = [ "buildPhase" "installPhase" "postFixup" ];

  buildPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share
    mkdir -p $out/share/man/man1
  '';

  installPhase = ''
    cp $src/translate $out/bin/trans
    cp $src/translate $out/bin/translate
    cp $src/translate $out/bin/translate-shell

    cp $src/translate.awk $out/share/translate.awk
    cp $src/build.awk $out/share/build.awk
    cp $src/metainfo.awk $out/share/metainfo.awk
    cp $src/test.awk $out/share/test.awk

    cp -r $src/include $out/share
    cp -r $src/test $out/share
    cp $src/man/trans.1 $out/share/man/man1

    chmod +x $out/bin/translate
    chmod +x $out/share/translate.awk
    chmod +x $out/share/build.awk
    chmod +x $out/share/metainfo.awk
    chmod +x $out/share/test.awk
  '';

  postFixup = ''
    substituteInPlace $out/bin/trans --replace "/bin/sh" "${bash}/bin/bash"
    substituteInPlace $out/bin/trans --replace "gawk " "${gawk}/bin/gawk "
    substituteInPlace $out/bin/trans --replace "translate.awk" "$out/share/translate.awk"

    substituteInPlace $out/bin/translate --replace "/bin/sh" "${bash}/bin/bash"
    substituteInPlace $out/bin/translate --replace "gawk " "${gawk}/bin/gawk "
    substituteInPlace $out/bin/translate --replace "translate.awk" "$out/share/translate.awk"

    substituteInPlace $out/bin/translate-shell --replace "/bin/sh" "${bash}/bin/bash"
    substituteInPlace $out/bin/translate-shell --replace "gawk " "${gawk}/bin/gawk "
    substituteInPlace $out/bin/translate-shell --replace "translate.awk" "$out/share/translate.awk"

    substituteInPlace $out/share/translate.awk --replace "/usr/bin/gawk" "${gawk}/bin/gawk"
    substituteInPlace $out/share/translate.awk --replace "metainfo" "$out/share/metainfo"
    substituteInPlace $out/share/translate.awk --replace "include/" "$out/share/include/"

    substituteInPlace $out/share/build.awk --replace "/usr/bin/gawk" "${gawk}/bin/gawk"
    substituteInPlace $out/share/build.awk --replace "include/" "$out/share/include/"
    substituteInPlace $out/share/build.awk --replace "metainfo.awk" "$out/share/metainfo.awk"

    substituteInPlace $out/share/metainfo.awk --replace "translate.awk" "$out/share/translate.awk"

    substituteInPlace $out/share/test.awk --replace "/usr/bin/gawk" "${gawk}/bin/gawk"
    substituteInPlace $out/share/test.awk --replace "include/" "$out/share/include/"
    substituteInPlace $out/share/test.awk --replace "test/" "$out/share/test/"

    substituteInPlace $out/share/include/Translators/\*.awk --replace "include/" "$out/share/include/"

    substituteInPlace $out/share/test/Test.awk --replace "test/" "$out/share/test/"
    substituteInPlace $out/share/test/TestUtils.awk --replace "include/" "$out/share/include/"
    substituteInPlace $out/share/test/TestParser.awk --replace "include/" "$out/share/include/"
    substituteInPlace $out/share/test/TestCommons.awk --replace "\"gawk\"" "\"${gawk}/bin/gawk\""
    substituteInPlace $out/share/test/TestCommons.awk --replace "Commons.awk" "$out/share/include/Commons.awk"

    substituteInPlace $out/share/include/Main.awk --replace "\"tput\"" "\"${ncurses.out}/bin/tput\""
    substituteInPlace $out/share/include/Help.awk --replace "\"groff\"" "\"${groff}/bin/groff\""
    substituteInPlace $out/share/include/Utils.awk --replace "\"fribidi\"" "\"${fribidi}/bin/fribidi\""
    substituteInPlace $out/share/include/Utils.awk --replace "\"fribidi " "\"${fribidi}/bin/fribidi "
    substituteInPlace $out/share/include/Utils.awk --replace "\"rlwrap\"" "\"${rlwrap}/bin/rlwrap\""
    substituteInPlace $out/share/include/Utils.awk --replace "\"emacs\"" "\"${emacs}/bin/emacs\""
    substituteInPlace $out/share/include/Utils.awk --replace "\"curl\"" "\"${curl.bin}/bin/curl\""

    substituteInPlace $out/share/build.awk --replace "\"pandoc " "\"${pandoc}/bin/pandoc "

    substituteInPlace $out/share/include/Translate.awk --replace "\"mpv " "\"${mpv}/bin/mpv "
    substituteInPlace $out/share/include/Translate.awk --replace "\"less " "\"${less}/bin/less "

  '';

  meta = with stdenv.lib; {
    homepage = https://www.soimort.org/translate-shell;
    description = "Command-line translator using Google Translate, Bing Translator, Yandex.Translate, and Apertium";
    license = licenses.publicDomain;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.unix;
  };
}
