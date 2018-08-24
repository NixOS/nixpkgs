{ stdenv, fetchurl
, flac, expat, libidn, qtbase, qtwebkit, libvorbis }:
assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  version = "beta_1.0.467.4929-r0"; # friendly to nix-env version sorting algo
  product = "google-musicmanager";
  name    = "${product}-${version}";

  # When looking for newer versions, since google doesn't let you list their repo dirs,
  # curl http://dl.google.com/linux/musicmanager/deb/dists/stable/Release
  # fetch an appropriate packages file such as main/binary-amd64/Packages:
  # curl http://dl.google.com/linux/musicmanager/deb/dists/stable/main/binary-amd64/Packages
  # which will contain the links to all available *.debs for the arch.

  src = fetchurl {
    url    = "http://dl.google.com/linux/musicmanager/deb/pool/main/g/google-musicmanager-beta/${name}_amd64.deb";
    sha256 = "0yaprpbp44var88kdj1h11fqkhgcklixr69jyia49v9m22529gg2";
  };

  unpackPhase = ''
    ar vx ${src}
    tar xvf data.tar.xz
    tar xvf control.tar.gz
  '';

  prePatch = ''
    sed -i "s@\(Exec=\).*@\1$out/bin/google-musicmanager@" opt/google/musicmanager/google-musicmanager.desktop
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    mkdir -p $out/share/applications

    cp -r opt $out
    find -name "*.so*" -exec cp "{}" $out/lib \;
    ln -s $out/opt/google/musicmanager/google-musicmanager $out/bin
    ln -s $out/opt/google/musicmanager/google-musicmanager.desktop $out/share/applications

    for i in 16 32 48 128
    do
      iconDirectory=$out/usr/share/icons/hicolor/"$i"x"$i"/apps

      mkdir -p $iconDirectory
      ln -s $out/opt/google/musicmanager/product_logo_"$i".png $iconDirectory/google-musicmanager.png
    done
  '';

  postFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$(patchelf --print-rpath $out/opt/google/musicmanager/minidump_upload):${stdenv.lib.makeLibraryPath [ stdenv.cc.cc.lib ]}" \
      $out/opt/google/musicmanager/minidump_upload

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$(patchelf --print-rpath $out/opt/google/musicmanager/MusicManager):$out/lib:${stdenv.lib.makeLibraryPath [
        flac
        expat
        libidn
        qtbase
        qtwebkit
        libvorbis
        stdenv.cc.cc.lib
      ]}" \
      $out/opt/google/musicmanager/MusicManager
  '';

  meta = with stdenv.lib; {
    description = "Uploads music from your computer to Google Play";
    homepage    = "https://support.google.com/googleplay/answer/1229970";
    license     = licenses.unfree;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.linux;
  };
}
