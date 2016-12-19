{ stdenv, fetchFromGitHub, wxGTK, libuuid, xercesc, zip , libXt, libXtst
, libXi, xextproto, gettext, perl, pkgconfig, libyubikey, ykpers
}:

stdenv.mkDerivation rec {
  name = "pwsafe-${version}";
  version = "0.99";

  src = fetchFromGitHub {
    owner = "pwsafe";
    repo = "pwsafe";
    rev = "${version}BETA";
    sha256 = "1bkimz4g9v9kfjkqr3dqddh4jps7anzc1hgmirmmhwpac0xdp60g";
  };

  makefile = "Makefile.linux";
  makeFlags = "YBPERS_LIBPATH=${ykpers}/lib";

  buildFlags = "unicoderelease";
  buildInputs = [ wxGTK libuuid gettext perl zip
                  xercesc libXt libXtst libXi xextproto
                  pkgconfig libyubikey ykpers ];

  postPatch = ''
    # Fix perl scripts used during the build.
    for f in `find . -type f -name '*.pl'`; do
      patchShebangs $f
    done

    # Fix hard coded paths.
    for f in `grep -Rl /usr/share/ src`; do
      substituteInPlace $f --replace /usr/share/ $out/share/
    done

    # Fix hard coded zip path.
    substituteInPlace help/Makefile.linux --replace /usr/bin/zip ${zip}/bin/zip

    for f in `grep -Rl /usr/bin/ .`; do
      substituteInPlace $f --replace /usr/bin/ ""
    done
  '';

  installPhase = ''
    mkdir -p $out/bin \
             $out/share/applications \
             $out/share/pwsafe/xml \
             $out/share/icons/hicolor/48x48/apps \
             $out/share/doc/passwordsafe/help \
             $out/share/man/man1 \
             $out/share/locale

    (cd help && make -f Makefile.linux)
    cp help/help*.zip $out/share/doc/passwordsafe/help

    (cd src/ui/wxWidgets/I18N && make mos)
    cp -dr src/ui/wxWidgets/I18N/mos/* $out/share/locale/
    # */

    cp README.txt docs/ReleaseNotes.txt docs/ChangeLog.txt \
      LICENSE install/copyright $out/share/doc/passwordsafe

    cp src/ui/wxWidgets/GCCUnicodeRelease/pwsafe $out/bin/
    cp install/graphics/pwsafe.png $out/share/icons/hicolor/48x48/apps
    cp docs/pwsafe.1 $out/share/man/man1
    cp xml/* $out/share/pwsafe/xml
    #  */
  '';

  meta = with stdenv.lib; {
    description = "A password database utility";

    longDescription = ''
      Password Safe is a password database utility. Like many other
      such products, commercial and otherwise, it stores your
      passwords in an encrypted file, allowing you to remember only
      one password (the "safe combination"), instead of all the
      username/password combinations that you use.
    '';

    homepage = http://passwordsafe.sourceforge.net/;
    maintainers = with maintainers; [ pjones ];
    platforms = platforms.linux;
    license = licenses.artistic2;
  };
}
