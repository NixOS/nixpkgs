{ lib
, stdenv
, fetchurl
, makeWrapper
, alsaLib
, at-spi2-atk
, at-spi2-core
, atk
, cairo
, cups
, dbus
, expat
, gdk-pixbuf
, glib
, gtk3
, libX11
, libXcomposite
, libXdamage
, libXext
, libXfixes
, libXrandr
, libdrm
, libxcb
, libxkbcommon
, libxshmfence
, mesa
, nspr
, nss
, pango
, systemd
, xdg-utils
}:
stdenv.mkDerivation rec {
  pname = "1password";
  version = "8.0.34";

  src = fetchurl {
    url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-${version}.x64.tar.gz";
    sha256 = "0mp119v5vgsva7pnxpsbq4xhh4vbhwv7ga9b5b7f6slx3biy1wmh";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;

  installPhase =
    let rpath = lib.makeLibraryPath [
      alsaLib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      gdk-pixbuf
      glib
      gtk3
      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXrandr
      libdrm
      libxcb
      libxkbcommon
      libxshmfence
      mesa
      nspr
      nss
      pango
      systemd
    ] + ":${stdenv.cc.cc.lib}/lib64";
    in ''
      runHook preInstall

      mkdir -p $out/bin $out/share/1password
      cp -a * $out/share/1password

      # Desktop file
      install -Dt $out/share/applications resources/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=/opt/1Password/${pname}' 'Exec=${pname}'

      # Icons
      cp -a resources/icons $out/share

      interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
      patchelf --set-interpreter $interp $out/share/1password/{1password,1Password-BrowserSupport,1Password-KeyringHelper}
      patchelf --set-rpath ${rpath}:$out/share/1password $out/share/1password/{1password,1Password-BrowserSupport,1Password-KeyringHelper}
      for file in $(find $out -type f -name \*.so\* ); do
        patchelf --set-rpath ${rpath}:$out/share/1password $file
      done

      makeWrapper $out/share/1password/1password $out/bin/1password \
        --prefix PATH : ${xdg-utils}/bin

      runHook postInstall
    '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Multi-platform password manager";
    homepage = "https://1password.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ danieldk timstott savannidgerinel ];
    platforms = [ "x86_64-linux" ];
  };
}
