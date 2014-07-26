{ stdenv, buildEnv, fetchurl, xlibs, glib, gtk2, atk, pango, gdk_pixbuf,
  cairo, freetype, fontconfig, nss, nspr, gnome, alsaLib, expat, dbus, udev,
  makeWrapper, writeScript, gnused }:

let

  rpath_env = buildEnv {
    name = "rpath_env";
    paths = [ xlibs.libX11 xlibs.libXrender glib xlibs.libXtst gtk2 atk pango
      gdk_pixbuf cairo freetype fontconfig xlibs.libXi xlibs.libXcomposite
      nss nspr gnome.GConf xlibs.libXext xlibs.libXfixes alsaLib
      xlibs.libXdamage expat dbus stdenv.gcc ];
    pathsToLink = [ "/lib" "/lib64" ];
  };

  name = "zed-${version}";
  version = "0.12.0";

  zed = stdenv.mkDerivation rec {
    inherit name version;

    src = if stdenv.system == "i686-linux" then fetchurl {
      url = "http://download.zedapp.org/zed-linux32-v${version}.tar.gz";
      sha256 = "04cygfhaynlpl8jrf2r55qk5zz1ipad8l9m8q81lfly2q0h9fbxi";
    } else fetchurl {
      url = "http://download.zedapp.org/zed-linux64-v${version}.tar.gz";
      sha256 = "0ng2v07fyglpbyl4pwm2bn5rbldw51kliw8rakbpcdia891hi6z1";
    };

    buildInputs = [ makeWrapper ];

    installPhase = ''
      mkdir -p $out/zed
      cp ./* $out/zed
    '';

    postFixup = ''
      patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" $out/zed/zed-bin
      patchelf --set-rpath "${rpath_env}/lib:${rpath_env}/lib64" $out/zed/zed-bin

      mkdir -p $out/lib
      ln -s ${udev}/lib/libudev.so.1 $out/lib/libudev.so.0

      wrapProgram $out/zed/zed-bin \
        --prefix LD_LIBRARY_PATH : $out/lib
    '';
  };
  zed_installer = writeScript "zed-installer.sh" ''
    mkdir -p ~/.zed
    cp -rv ${zed}/zed/* ~/.zed

    ${gnused}/bin/sed -ri 's/DIR\=\$\(dirname\ \$0\)/DIR\=\~\/\.zed/' ~/.zed/zed

    mkdir -p ~/bin
    ln -sv ~/.zed/zed ~/bin/zed
  '';

in stdenv.mkDerivation rec {
  inherit name version;

  src = zed;

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${zed_installer} $out/bin/zed-installer
  '';

  meta = {
    description = "Zed is a fully offline-capable, open source, keyboard-focused, text and code editor for power users";
    license = stdenv.lib.licenses.mit;
    homepage = http://zedapp.org/;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
  };
}
