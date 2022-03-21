{ lib
, stdenv
, fetchurl
, makeWrapper
, alsa-lib
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
, udev
, xdg-utils
}:
stdenv.mkDerivation rec {
  pname = "1password";
  version = "8.5.0";

  src = fetchurl {
    url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-${version}.x64.tar.gz";
    sha256 = "tnZr+qjUcJ9Fhk6RP8iwu+/JsvYSE03NHhBfhedyCTQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;

  installPhase =
    let rpath = lib.makeLibraryPath [
      alsa-lib
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

      # Polkit file
      install -Dm 0644 -t $out/share/polkit-1/actions com.1password.1Password.policy

      # Icons
      cp -a resources/icons $out/share

      interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
      patchelf --set-interpreter $interp $out/share/1password/{1password,1Password-BrowserSupport,1Password-KeyringHelper}
      patchelf --set-rpath ${rpath}:$out/share/1password $out/share/1password/{1password,1Password-BrowserSupport,1Password-KeyringHelper}
      for file in $(find $out -type f -name \*.so\* ); do
        patchelf --set-rpath ${rpath}:$out/share/1password $file
      done

      # Electron is trying to open udev via dlopen()
      # and for some reason that doesn't seem to be impacted from the rpath.
      # Adding udev to LD_LIBRARY_PATH fixes that.
      makeWrapper $out/share/1password/1password $out/bin/1password \
        --prefix PATH : ${lib.makeBinPath [ xdg-utils ]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]}

      runHook postInstall
    '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Multi-platform password manager";
    homepage = "https://1password.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ timstott savannidgerinel ];
    platforms = [ "x86_64-linux" ];
  };
}
