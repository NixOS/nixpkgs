{ stdenv, fetchurl, makeWrapper, file, boost165, protobuf3_0, openssl_1_1, icu58, glib, xorg, libGL, libpulseaudio, qt56 }:

stdenv.mkDerivation rec {
  name = "${pname}-${builtins.replaceStrings ["~"] ["-"] version}";
  pname = "teradici-pcoip-client";
  version = "3.9.0~dev11";

  src = fetchurl {
    inherit name;
    url = "https://downloads.teradici.com/ubuntu/pool/non-free/p/pcoip-client/pcoip-client_${version}-18.04_amd64.deb";
    sha256 = "01yx8x7pk6s4nvkb5v62s7ixgqc3s44g5kqgzzr0xwzijgvhkw8j";
  };

  unpackPhase = ''
    ar x $src
    tar xf data.tar.*
  '';

  nativeBuildInputs = [ makeWrapper file ];

  dontBuild = true;

  libPath = stdenv.lib.makeLibraryPath [
    boost165
    glib
    libGL
    libpulseaudio
    openssl_1_1
    protobuf3_0
    icu58
    stdenv.cc.cc
    xorg.libX11
    qt56.qtbase
    qt56.qtx11extras
    # qt56.qtdeclarative
    qt56.qtxmlpatterns
    qt56.qtscript
  ];

  installPhase = ''
    lib_dir=usr/lib/x86_64-linux-gnu/pcoip-client

    # Get rid of vendored dependencies:
    # =================================

    # We get this one from icu58
    rm -v $lib_dir/libicu*

    # This one we keep because we don't know how to build it (see https://stackoverflow.com/questions/55071459/how-can-i-build-libqt5declarative-so):
    mv $lib_dir/libQt5Declarative.so.* usr/lib

    # The other QT ones we've got:
    rm -rv $lib_dir/libQt5*

    # The QT plugings we've got as well, thanks to the wrapper setting QT_PLUGIN_PATH below:
    rm -rv $lib_dir/plugins

    # The rest appears to be actual Teradici stuff:
    mv -v $lib_dir/* usr/lib
    rm -rv usr/lib/x86_64-linux-gnu

    mv -v usr/libexec/pcoip-client/pcoip-client usr/bin/pcoip-client
    mkdir -p $out
    mv -v usr/bin usr/sbin usr/lib usr/share $out

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/bin/pcoip-client

    find $out -type f -exec file {} \; |
      grep 'ELF.*shared object' |
      cut -f 1 -d : |
      xargs -d '\n' -n 1 -t -I {} patchelf \
        --set-rpath "$out/lib:$libPath" {}

    wrapProgram $out/bin/pcoip-client --set QT_PLUGIN_PATH ${qt56.qtbase}/lib/qt-5.6/plugins
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    homepage = http://www.teradici.com/web-help/pcoip_client/linux/3.8.1/installation/installing_the_client_overview/;
    license = licenses.unfree;
    description = "Teradici PCoIP Software Client (compatible with Amazon Workspaces)";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ obadz ];
  };
}
