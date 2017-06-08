{ stdenv, fetchurl, makeWrapper, dpkg, dbus, libpulseaudio, 
  glib, lsof, libX11, libXScrnSaver, qt5, zlib, mesa_noglu,
  openssl, libxcb, libXi, libXmu }:

stdenv.mkDerivation rec {
  name = "enpass-${version}";
  version = "5.3.0";

  src = fetchurl {
    url = "http://repo.sinew.in/pool/main/e/enpass/enpass_${version}_amd64.deb";
    sha256 = "d9da061c6456281da836bdd78bdb7baeced4b7f1805bb2495e4f1d15038cf86b";
  };

  deps = [ lsof 
           libX11 
           libXScrnSaver 
           libXi
           libXmu
           libxcb
           stdenv.cc.cc
           dbus
           glib
           zlib
           mesa_noglu
           libpulseaudio
           qt5.qtbase
           openssl
         ];

  nativeBuildInputs = [ dpkg makeWrapper ];

  unpackPhase = "true";

  installPhase = 
    ''
      librarypath="${stdenv.lib.makeLibraryPath deps}:$out/opt/Enpass/lib:$out/opt/Enpass/plugins/sqldrivers"

      # extract the debian package
      dpkg-deb -x $src $out

      mkdir -p $out/bin
      #ln -s $out/opt/Enpass/bin/runenpass.sh $out/bin/enpass
      ln -s $out/opt/Enpass/bin/Enpass $out/bin/enpass

      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "$librarypath" $out/opt/Enpass/bin/Enpass
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "$librarypath" $out/opt/Enpass/bin/EnpassHelper/EnpassHelper

        wrapProgram $out/opt/Enpass/bin/Enpass \
        --prefix LD_LIBRARY_PATH : "$librarypath" \
        --prefix QT_PLUGIN_PATH : "$out/opt/Enpass/plugins:$QT_PULGIN_PATH" \
        --prefix QT_QPA_PLATFORM_PLUGIN_PATH : "$out/opt/Enpass/plugins/platforms"

        wrapProgram $out/opt/Enpass/bin/EnpassHelper/EnpassHelper \
        --prefix LD_LIBRARY_PATH : "$librarypath" \
        --prefix QT_PLUGIN_PATH : "$out/opt/Enpass/plugins:$QT_PLUGIN_PATH" \
        --prefix QT_QPA_PLATFORM_PLUGIN_PATH : "$out/opt/Enpass/plugins/platforms"
    '';

  meta = with stdenv.lib; {
    description = "A cross-platform password manager";
    homepage = https://enpass.io/;
    license = licenses.unfreeRedistributable;
    maintainers = [ maintainers.s1lvester ];
    platforms = [ "x86_64-linux" ];
  };
}
