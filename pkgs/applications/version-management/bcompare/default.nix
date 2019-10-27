{ autoPatchelfHook, bzip2, cairo, coreutils, fetchurl, gdk-pixbuf, gnome2, gtk2, kcoreaddons, ki18n, kio, kservice, lib, qt4, qt511, qtbase, stdenv, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "bcompare";
  version = "4.3.0.24364";

  src = fetchurl {
    url = "https://www.scootersoftware.com/${pname}-${version}_amd64.deb";
    sha256 = "14ff250nyqfqgm9qazg4la7ajci3bhqm376wy2j3za1vf09774kc";
  };

  unpackPhase = ''
    ar x $src
    tar xfz data.tar.gz
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/share
    cp -R usr/share $out/
    cp -R usr/lib $out/
    cp -R usr/bin $out/

    # Remove library that refuses to be autoPatchelf'ed
    rm $out/lib/beyondcompare/ext/bcompare_ext_kde.amd64.so

    substituteInPlace $out/bin/bcompare \
      --replace "/usr/lib/beyondcompare" "$out/lib/beyondcompare" \
      --replace "/bin/bash" "${runtimeShell}"

    # Create symlink bzip2 library
    ln -s ${bzip2.out}/lib/libbz2.so.1 $out/lib/beyondcompare/libbz2.so.1.0
  '';

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    gtk2
    gnome2.pango
    cairo
    kio
    kservice
    ki18n
    kcoreaddons
    gdk-pixbuf
    qt4
    bzip2
  ];

  dontBuild = true;
  dontConfigure = true;

  meta = with stdenv.lib; {
    description = "GUI application that allows to quickly and easily compare files and folders";
    longDescription = ''
      Beyond Compare is focused. Beyond Compare allows you to quickly and easily compare your files and folders.
      By using simple, powerful commands you can focus on the differences you're interested in and ignore those you're not.
      You can then merge the changes, synchronize your files, and generate reports for your records.
    '';
    homepage = "https://www.scootersoftware.com";
    license = licenses.unfree;
    maintainers = [ maintainers.ktor ];
    platforms = [ "x86_64-linux" ];
  };

}
