{
  lib,
  stdenv,
  pname,
  version,
  src,
  meta,
  makeShellWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libdrm,
  libxcb,
  libxkbcommon,
  libxshmfence,
  libGL,
  libappindicator-gtk3,
  libgbm,
  nspr,
  nss,
  pango,
  systemd,
  udev,
  xdg-utils,

  # The 1Password polkit file requires a list of users for whom polkit
  # integrations should be enabled. This should be a list of strings that
  # correspond to usernames.
  polkitPolicyOwners ? [ ],
}:
let
  # Convert the polkitPolicyOwners variable to a polkit-compatible string for the polkit file.
  policyOwners = lib.concatStringsSep " " (map (user: "unix-user:${user}") polkitPolicyOwners);

in
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [
    makeShellWrapper
    wrapGAppsHook3
  ];
  buildInputs = [ glib ];

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  dontWrapGApps = true;

  installPhase =
    let
      rpath =
        lib.makeLibraryPath [
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
          libgbm
          nspr
          nss
          pango
          systemd
        ]
        + ":${lib.getLib stdenv.cc.cc}/lib64";
    in
    ''
      runHook preInstall

      mkdir -p $out/bin $out/share/1password
      cp -a * $out/share/1password

      # Desktop file
      install -Dt $out/share/applications resources/1password.desktop
      substituteInPlace $out/share/applications/1password.desktop \
        --replace-fail 'Exec=/opt/1Password/1password' 'Exec=1password'

    ''
    + (lib.optionalString (polkitPolicyOwners != [ ]) ''
      # Polkit file
        mkdir -p $out/share/polkit-1/actions
        substitute com.1password.1Password.policy.tpl $out/share/polkit-1/actions/com.1password.1Password.policy --replace-fail "\''${POLICY_OWNERS}" "${policyOwners}"
    '')
    + ''

      # Icons
      cp -a resources/icons $out/share

      interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
      patchelf --set-interpreter $interp $out/share/1password/{1password,1Password-BrowserSupport,1Password-LastPass-Exporter,op-ssh-sign}
      patchelf --set-rpath ${rpath}:$out/share/1password $out/share/1password/{1password,1Password-BrowserSupport,1Password-LastPass-Exporter,op-ssh-sign}
      for file in $(find $out -type f -name \*.so\* ); do
        patchelf --set-rpath ${rpath}:$out/share/1password $file
      done

      ln -s $out/share/1password/op-ssh-sign $out/bin/op-ssh-sign

      runHook postInstall
    '';

  preFixup = ''
    # makeWrapper defaults to makeBinaryWrapper due to wrapGAppsHook
    # but we need a shell wrapper specifically for `NIXOS_OZONE_WL`.
    # Electron is trying to open udev via dlopen()
    # and for some reason that doesn't seem to be impacted from the rpath.
    # Adding udev to LD_LIBRARY_PATH fixes that.
    # Make xdg-open overrideable at runtime.
    makeShellWrapper $out/share/1password/1password $out/bin/1password \
      "''${gappsWrapperArgs[@]}" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]} \
      --add-flags "\''${NIXOS_OZONE_WL:+--ozone-platform-hint=auto}"
  '';

  passthru.updateScript = ./update.sh;
}
