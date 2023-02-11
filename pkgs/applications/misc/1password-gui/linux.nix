{ lib
, stdenv
, pname
, version
, src
, meta
, makeWrapper
, wrapGAppsHook
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
, libGL
, libappindicator-gtk3
, mesa
, nspr
, nss
, pango
, systemd
, udev
, xdg-utils

  # The 1Password polkit file requires a list of users for whom polkit
  # integrations should be enabled. This should be a list of strings that
  # correspond to usernames.
, polkitPolicyOwners ? []
}:
let
  # Convert the polkitPolicyOwners variable to a polkit-compatible string for the polkit file.
  policyOwners = lib.concatStringsSep " " (map (user: "unix-user:${user}") polkitPolicyOwners);

in stdenv.mkDerivation {
  inherit pname version src meta;

  nativeBuildInputs = [ makeWrapper wrapGAppsHook ];
  buildInputs = [ glib ];

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  dontWrapGApps = true;

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
      libGL
      libappindicator-gtk3
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

      '' + (lib.optionalString (polkitPolicyOwners != [ ])
      ''
      # Polkit file
        mkdir -p $out/share/polkit-1/actions
        substitute com.1password.1Password.policy.tpl $out/share/polkit-1/actions/com.1password.1Password.policy --replace "\''${POLICY_OWNERS}" "${policyOwners}"
        '') + ''

      # Icons
      cp -a resources/icons $out/share

      interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
      patchelf --set-interpreter $interp $out/share/1password/{1password,1Password-BrowserSupport,1Password-KeyringHelper,op-ssh-sign}
      patchelf --set-rpath ${rpath}:$out/share/1password $out/share/1password/{1password,1Password-BrowserSupport,1Password-KeyringHelper,op-ssh-sign}
      for file in $(find $out -type f -name \*.so\* ); do
        patchelf --set-rpath ${rpath}:$out/share/1password $file
      done

      runHook postInstall
    '';

  preFixup = ''
    # Electron is trying to open udev via dlopen()
    # and for some reason that doesn't seem to be impacted from the rpath.
    # Adding udev to LD_LIBRARY_PATH fixes that.
    # Make xdg-open overrideable at runtime.
    makeWrapper $out/share/1password/1password $out/bin/1password \
      ''${gappsWrapperArgs[@]} \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';
}
