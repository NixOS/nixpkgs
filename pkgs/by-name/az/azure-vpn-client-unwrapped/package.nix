{
  # keep-sorted start
  alsa-lib,
  at-spi2-core,
  atk,
  autoPatchelfHook,
  cacert,
  cairo,
  cups,
  curl,
  dbus,
  dpkg,
  expat,
  fetchurl,
  glib,
  gtk2,
  gtk3,
  lib,
  libcap,
  libdrm,
  libsecret,
  libuuid,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxshmfence,
  makeWrapper,
  mesa,
  nspr,
  nss,
  openssl,
  openvpn,
  pango,
  patchelf,
  pkg-config,
  runCommand,
  stdenv,
  stdenvNoCC,
  systemdLibs,
  xdg-utils,
  zenity,
  # keep-sorted end
}:
let
  # The VPN relies on old behavior of Systemd. The interactive flag was set by
  # it in the version the VPN expects.
  # This was removed in:
  # https://github.com/systemd/systemd/commit/7b36fb9f96fd5c1f63b9f0f9e75194e3e4dd6a8d.
  # This shims the DBus open call and sets the interactive flag.
  interactiveAuthShim = stdenv.mkDerivation {
    name = "auth-shim";
    src = ./interactive-auth-shim.c;

    dontUnpack = true;

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ systemdLibs ];

    buildPhase = ''
      gcc -shared -fPIC \
        $src \
        -o libinteractive-auth-shim.so \
        -lsystemd
    '';

    installPhase = ''
      mkdir -p $out/lib
      cp libinteractive-auth-shim.so $out/lib/
    '';
  };

  # Convert the .crt files into a format the VPN is happy with. Other formats fail.
  toPem =
    source:
    runCommand "to-pem" { nativeBuildInputs = [ openssl ]; } ''
      openssl x509 -in "${source}" -out $out -outform PEM
    '';

  # From: https://docs.azure.cn/en-us/vpn-gateway/point-to-site-entra-vpn-client-linux#import-client-profile-configuration-settings
  # > View the connection profile information. Change the Certificate Information
  # > value to show the default DigiCert_Global_Root G2.pem or
  # > DigiCert_Global_Root_CA.pem. Don't leave blank.
  certificates = {
    # keep-sorted start
    "DigiCert_Global_Root_CA.pem" =
      toPem "${cacert.unbundled}/etc/ssl/certs/DigiCert_Global_Root_CA:83be056904246b1a1756ac95991c74a.crt";
    "DigiCert_Global_Root_G2.pem" =
      toPem "${cacert.unbundled}/etc/ssl/certs/DigiCert_Global_Root_G2:33af1e6a711a9a0bb2864b11d09fae5.crt";
    # keep-sorted end
  };

  runtimeLibs = [
    # keep-sorted start
    alsa-lib
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    glib
    gtk2
    gtk3
    libcap
    libdrm
    libsecret
    libuuid
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    libxshmfence
    mesa
    nspr
    nss
    openssl
    pango
    stdenv.cc.cc.lib
    systemdLibs
    # keep-sorted end
  ];
in
stdenvNoCC.mkDerivation rec {
  pname = "azure-vpn-client-unwrapped";
  version = "3.0.0";

  src = fetchurl {
    url = "https://packages.microsoft.com/ubuntu/22.04/prod/pool/main/m/microsoft-azurevpnclient/microsoft-azurevpnclient_${version}_amd64.deb";
    hash = "sha256-nl02BDPR03TZoQUbspplED6BynTr6qNRVdHw6fyUV3s=";
  };

  nativeBuildInputs = [
    # keep-sorted start
    autoPatchelfHook
    dpkg
    makeWrapper
    patchelf
    # keep-sorted end
  ];

  buildInputs = runtimeLibs;
  runtimeDependencies = runtimeLibs;

  strictDeps = true;
  __structuredAttrs = true;

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt $out/bin $out/lib $out/share

    cp -r opt/microsoft $out/opt/
    cp -r usr/share/* $out/share/
    # remove broken polkit configuration
    rm -r $out/share/polkit-1
    # remove the desktop item to avoid confusion, it cannot be used since the
    # program requires a security wrapper
    rm $out/share/applications/microsoft-azurevpnclient.desktop

    addAutoPatchelfSearchPath $out/opt/microsoft/microsoft-azurevpnclient/lib

    makeWrapper \
      $out/opt/microsoft/microsoft-azurevpnclient/microsoft-azurevpnclient \
      $out/bin/microsoft-azurevpnclient \
      --prefix PATH : "${
        lib.makeBinPath [
          openvpn
          zenity
          xdg-utils
        ]
      }" \
      --prefix LD_LIBRARY_PATH : "$out/opt/microsoft/microsoft-azurevpnclient/lib"

    chmod +x $out/bin/microsoft-azurevpnclient

    runHook postInstall
  '';

  # Use `patchelf` instead of `LD_PRELOAD` because we will need privileges
  postInstall = ''
    cp ${interactiveAuthShim}/lib/libinteractive-auth-shim.so \
      $out/opt/microsoft/microsoft-azurevpnclient/lib/
    patchelf --add-needed libinteractive-auth-shim.so \
      $out/opt/microsoft/microsoft-azurevpnclient/microsoft-azurevpnclient
  '';

  passthru = {
    inherit certificates toPem;
  };

  meta = with lib; {
    description = "Microsoft Azure VPN Client for Linux";
    longDescription = ''
      The VPN needs a specific ssl certification structure and a security
      wrapper to work. Please see the wrapper and NixOS module for more
      information.
    '';
    homepage = "https://learn.microsoft.com/en-us/azure/vpn-gateway/point-to-site-entra-vpn-client-linux";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "microsoft-azurevpnclient";
    maintainers = [ maintainers.elias-graf ];
  };
}
