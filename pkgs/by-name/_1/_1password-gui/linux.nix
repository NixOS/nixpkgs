{
  lib,
  stdenv,
  pname,
  version,
  src,
  meta,

  # nativeBuildInputs
  autoPatchelfHook,
  makeShellWrapper,
  wrapGAppsHook3,

  # buildInputs
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
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libdrm,
  libxcb,
  libxkbcommon,
  libxshmfence,
  libGL,
  libgbm,
  nspr,
  nss,
  pango,
  systemd,

  # runtime dependencies
  libappindicator,
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
    autoPatchelfHook
    makeShellWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
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
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libdrm
    libxcb
    libxkbcommon
    libxshmfence
    libgbm
    nspr
    nss
    pango
    systemd
    (lib.getLib stdenv.cc.cc)
  ];

  # Electron loads this with dlopen(), so it never appears in DT_NEEDED.
  runtimeDependencies = [ libappindicator ];

  # Applied to every patched file, including bundled libraries (¯\_(ツ)_/¯)
  # ANGLE's libGLESv2.so dlopen()s libEGL.so.1 itself, and Electron dlopen()s
  # libraries bundled next to its executable.
  appendRunpaths = [
    "${lib.getLib libGL}/lib"
    "${placeholder "out"}/share/1password"
  ];

  dontConfigure = true;
  dontBuild = true;
  # Keep patchELF's --shrink-rpath from removing the dlopen()-only entries above.
  dontPatchELF = true;
  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/1password
    cp -a * $out/share/1password

    # Desktop file
    install -Dt $out/share/applications resources/*.desktop
    substituteInPlace $out/share/applications/*.desktop \
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
