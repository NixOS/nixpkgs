{
  lib,
  rustPlatform,
  stdenv,
  atk,
  autoconf,
  automake,
  cairo,
  coreutils,
  gawk,
  glib,
  glib-networking,
  gmp,
  gnutls,
  gnugrep,
  gpauth,
  gtk3,
  iproute2,
  libtool,
  libxml2,
  lz4,
  makeBinaryWrapper,
  net-tools,
  nettle,
  openresolv,
  openssl,
  p11-kit,
  pango,
  perl,
  pkg-config,
  systemd,
  zlib,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

rustPlatform.buildRustPackage {
  pname = "gpclient";

  # Keep automatic updates anchored on gpauth so the bot updates both
  # package outputs in one PR.
  # nixpkgs-update: no auto update
  inherit (gpauth)
    cargoHash
    meta
    src
    version
    ;

  buildAndTestSubdir = "apps/gpclient";

  nativeBuildInputs = [
    makeBinaryWrapper
    perl
    pkg-config

    # used to build vendored openconnect
    autoconf
    automake
    libtool
  ];
  buildInputs = [
    glib
    glib-networking
    gmp
    gnutls
    gpauth

    # used for vendored openconnect
    libxml2
    lz4
    nettle
    openssl
    p11-kit
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    atk
    cairo
    gtk3
    pango
  ];

  postPatch = ''
    substituteInPlace crates/openconnect/src/vpn_utils.rs \
      --replace-fail /usr/libexec/gpclient/vpnc-script $out/libexec/gpclient/vpnc-script \
      --replace-fail /usr/libexec/gpclient/hipreport.sh $out/libexec/gpclient/hipreport.sh

    substituteInPlace crates/common/src/constants.rs \
      --replace-fail /usr/bin/gpauth ${gpauth}/bin/gpauth \
      --replace-fail /opt/homebrew/bin/gpauth ${gpauth}/bin/gpauth \
      --replace-fail /usr/local/bin/gpauth ${gpauth}/bin/gpauth \
      --replace-fail /usr/bin/gpclient $out/bin/gpclient \
      --replace-fail /usr/bin/gpservice $out/bin/gpservice \
      --replace-fail /opt/homebrew/ $out/ \
      --replace-fail /usr/local/ $out/
  '';

  postInstall = ''
    cp -r packaging/files/usr/libexec $out/libexec

    substituteInPlace $out/libexec/gpclient/hipreport.sh \
      --replace-fail /usr/bin/gpclient $out/bin/gpclient
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $out/libexec/gpclient/vpnc-script \
      --replace-fail /sbin/resolvconf ${openresolv}/bin/resolvconf
  ''
  + lib.optionalString withSystemd ''
    substituteInPlace $out/libexec/gpclient/vpnc-script \
      --replace-fail /usr/bin/resolvectl ${systemd}/bin/resolvectl \
      --replace-fail /usr/bin/busctl ${systemd}/bin/busctl
  ''
  + ''
    wrapProgram "$out/libexec/gpclient/vpnc-script" \
      --prefix PATH : "${
        lib.makeBinPath (
          [
            coreutils
            gawk
            gnugrep
            net-tools
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            iproute2
            openresolv
          ]
        )
      }"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    cp -r packaging/files/usr/lib $out/lib
    substituteInPlace $out/lib/NetworkManager/dispatcher.d/pre-down.d/gpclient.down \
      --replace-fail /usr/bin/gpclient $out/bin/gpclient

    install -Dm644 packaging/files/usr/share/applications/gpgui.desktop \
      $out/share/applications/gpgui.desktop
    substituteInPlace $out/share/applications/gpgui.desktop \
      --replace-fail /usr/bin/gpclient $out/bin/gpclient
  '';

  postFixup = ''
    wrapProgram "$out/bin/gpclient" \
      --prefix GIO_EXTRA_MODULES : ${glib-networking}/lib/gio/modules
  '';
}
