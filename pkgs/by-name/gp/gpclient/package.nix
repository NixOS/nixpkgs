{
  lib,
  rustPlatform,
  stdenv,
  fetchFromGitHub,
  atk,
  autoconf,
  automake,
  cairo,
  coreutils,
  darwin,
  gawk,
  glib,
  glib-networking,
  gmp,
  gnutls,
  gnugrep,
  gnused,
  gpauth,
  gtk3,
  iproute2,
  libtool,
  libxml2,
  lz4,
  makeBinaryWrapper,
  net-tools,
  nettle,
  nix-update-script,
  openresolv,
  openssl,
  p11-kit,
  pango,
  pciutils,
  perl,
  pkg-config,
  replaceVars,
  runtimeShell,
  systemd,
  unixtools,
  zlib,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

let
  runtimePath = lib.makeBinPath (
    [
      coreutils
      gawk
      unixtools.ps
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      iproute2
      pciutils # lspci
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.DarwinTools # sw_vers
    ]
    ++ lib.optionals withSystemd [
      systemd # resolvectl, systemctl, systemd-detect-virt
    ]
  );
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gpclient";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QQPi7ex/VwVhyBrgRaJugJog7x3WbatDgD7gdNkmxr0=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-bMLbvofHnGOcydcLJVZJt54sAXLPayNu8hl2zETx8uI=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--use-github-releases" ];
  };

  meta = gpauth.meta // {
    # Anchor meta.position here so nixpkgs-update targets gpclient.
    inherit (gpauth.meta) description;
  };

  buildAndTestSubdir = "apps/gpclient";

  nativeBuildInputs = [
    makeBinaryWrapper
    perl
    pkg-config

    # used to build vendored openconnect
    autoconf
    automake
    libtool
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.sigtool
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

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # Fail in sandbox because netdev tries to read SystemConfiguration
    "--skip=connect::args::tests::deprecated_profile_override_flags_do_not_affect_os_profile"
    "--skip=connect::args::tests::stdin_host_id_sets_profile_runtime_identity_seed"
    "--skip=connect::flow_tests::"
    "--skip=session::tests::builds_session_context_from_os_profile"
  ];

  patches = [
    (replaceVars ./diagnostics-runtime.patch {
      inherit runtimeShell runtimePath;
    })
  ];

  postPatch = ''
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
    # Install the supporting files, including the relocatable Darwin OpenConnect library.
    make install-gpclient PREFIX="$out" CARGO_RELEASE_DIR="$releaseDir"
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
            gnused
            net-tools
            unixtools.ps
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

    # The dispatcher skips dotfiles, so the .gpclient-nm-hook-wrapped
    # payload next to the wrapper is not run as a second script.
    wrapProgram "$out/lib/NetworkManager/dispatcher.d/gpclient-nm-hook" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          gnugrep
          unixtools.ps
        ]
      }"

    install -Dm644 packaging/files/usr/share/applications/gpgui.desktop \
      $out/share/applications/gpgui.desktop
    substituteInPlace $out/share/applications/gpgui.desktop \
      --replace-fail /usr/bin/gpclient $out/bin/gpclient
  '';

  postFixup = ''
    # Collectors use GP_COMMAND_PATH instead of PATH.
    wrapProgram "$out/bin/gpclient" \
      --prefix PATH : "${runtimePath}" \
      --prefix GP_COMMAND_PATH : "${runtimePath}" \
      --prefix GIO_EXTRA_MODULES : ${glib-networking}/lib/gio/modules
  '';
})
