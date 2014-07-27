{ stdenv, buildEnv, fetchgit, xlibs, glib, gtk2, atk, pango, gdk_pixbuf,
  cairo, freetype, fontconfig, nss, nspr, gnome, alsaLib, expat, dbus, udev,
  makeWrapper, writeScript, fetchurl, zip, pkgs, node_webkit }:

let
  name = "zed-${version}";
  version = "0.12";

  rpath_env = buildEnv {
    name = "rpath_env";
    paths = [ xlibs.libX11 xlibs.libXrender glib xlibs.libXtst gtk2 atk pango
      gdk_pixbuf cairo freetype fontconfig xlibs.libXi xlibs.libXcomposite
      nss nspr gnome.GConf xlibs.libXext xlibs.libXfixes alsaLib
      xlibs.libXdamage expat dbus stdenv.gcc ];
    pathsToLink = [ "/lib" "/lib64" ];
  };

  # When upgrading node.nix / node packages:
  #   fetch package.json from Zed's repository
  #   run `npm2nix package.json node.nix`
  #   and replace node.nix with new one
  nodePackages = import ../../../../pkgs/top-level/node-packages.nix {
    inherit pkgs;
    inherit (pkgs) stdenv nodejs fetchurl fetchgit;
    neededNatives = [ pkgs.python ] ++ pkgs.lib.optional pkgs.stdenv.isLinux pkgs.utillinux;
    self = nodePackages;
    generated = ./node.nix;
  };

  node_env = buildEnv {
    name = "node_env";
    paths = [ nodePackages.tar nodePackages.request ];
    pathsToLink = [ "/lib" ];
  };

  zed = stdenv.mkDerivation rec {
    inherit name version;

    src = fetchgit {
        url = "git://github.com/zedapp/zed";
        rev = "refs/tags/v${version}";
        sha256 = "1l1adj4p916km626vxg1lv0bapzay4z5nq005pxsbjbcycrhds59";
      };

    buildInputs = [ makeWrapper zip ];

    dontBuild = true;

    installPhase = ''
      export NWPATH="${node_webkit}/share/node-webkit";

      mkdir -p $out/zed

      cd ${src}/app; zip -r $out/zed/app.nw *; cd ..

      cat $NWPATH/nw $out/zed/app.nw > $out/zed/zed-bin
      cp $NWPATH/nw.pak $out/zed/
      cp nw/zed-linux $out/zed/zed
      chmod +x $out/zed/zed*
      cp Zed.desktop.tmpl Zed.svg Zed.png $out/zed
      rm $out/zed/app.nw
    '';

    postFixup = ''
      patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" $out/zed/zed-bin
      patchelf --set-rpath "${rpath_env}/lib:${rpath_env}/lib64" $out/zed/zed-bin

      mkdir -p $out/lib
      ln -s ${udev}/lib/libudev.so.1 $out/lib/libudev.so.0

      wrapProgram $out/zed/zed-bin \
        --prefix LD_LIBRARY_PATH : $out/lib \
        --prefix NODE_PATH : ${node_env}/lib/node_modules
    '';
  };

  zed_script = writeScript "zed.sh" ''
    if [[ $1 == http://* ]] || [[ $1 == https://* ]]; then
        PROJECT=$1
    elif [ "" != "$1" ]; then
       PROJECT=$(readlink -f $1)
    fi
    ${zed}/zed/zed-bin $PROJECT
  '';

in stdenv.mkDerivation rec {
  inherit name version;

  src = zed;

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${zed_script} $out/bin/zed
  '';

  meta = {
    description = "Zed is a fully offline-capable, open source, keyboard-focused, text and code editor for power users";
    license = stdenv.lib.licenses.mit;
    homepage = http://zedapp.org/;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
  };
}
