{ stdenv, fetchurl, buildEnv, gtk2, glib, gdk_pixbuf, alsaLib, nss, nspr, gconf
, cups, libgcrypt_1_5, systemd, makeWrapper, dbus }:
let
  bracketsEnv = buildEnv {
    name = "env-brackets";
    paths = [
      gtk2 glib gdk_pixbuf stdenv.cc.cc.lib alsaLib nss nspr gconf cups libgcrypt_1_5
      dbus.lib systemd.lib
    ];
  };
in
stdenv.mkDerivation rec {
  name = "brackets-${version}";
  version = "1.7";

  src = fetchurl {
    url = "https://github.com/adobe/brackets/releases/download/release-${version}/Brackets.Release.${version}.64-bit.deb";
    sha256 = "0nsiy3gvp8rd71a0misf6v1kz067kxnszr5mpch9fj4jqmg6nj8m";
    name = "${name}.deb";
  };

  phases = [ "installPhase" "fixupPhase" ];

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out
    ar p $src data.tar.xz | tar -C $out -xJ

    mv $out/usr/* $out/
    rmdir $out/usr
    ln -sf $out/opt/brackets/brackets $out/bin/brackets

    ln -s ${systemd.lib}/lib/libudev.so.1 $out/opt/brackets/lib/libudev.so.0

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${bracketsEnv}/lib:${bracketsEnv}/lib64" \
      $out/opt/brackets/Brackets

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/opt/brackets/Brackets-node

    patchelf \
      --set-rpath "${bracketsEnv}/lib:${bracketsEnv}/lib64" \
      $out/opt/brackets/lib/libcef.so

    wrapProgram $out/opt/brackets/brackets \
      --prefix LD_LIBRARY_PATH : "${bracketsEnv}/lib:${bracketsEnv}/lib64"

    substituteInPlace $out/opt/brackets/brackets.desktop \
      --replace "Exec=/opt/brackets/brackets" "Exec=brackets"
    mkdir -p $out/share/applications
    ln -s $out/opt/brackets/brackets.desktop $out/share/applications/
  '';

  meta = with stdenv.lib; {
    description = "An open source code editor for the web, written in JavaScript, HTML and CSS";
    homepage = http://brackets.io/;
    license = licenses.mit;
    maintainers = [ maintainers.matejc ];
    platforms = [ "x86_64-linux" ];
  };
}
