{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  bison,
  flex,
  curl,
  perl,
  gperf,
  openssl,
  pcsclite,
  networkmanager,
  openresolv,
  glib,
  systemd,
  tpm2-tss,
  libxml2,
  pam,
  iptables,
  trousers,
  sqlite,
  unbound,
  ldns,
  gmp,
  nixosTests,
  enableNetworkManager ? false,
  enableTNC ? false,
  enableTPM2 ? false,
}:
let
  features = rec {
    nm = enableNetworkManager;
    cmd = true;
    stroke = true;
    swanctl = true;
    systemd = stdenv.hostPlatform.isLinux;

    openssl = true;

    farp = stdenv.hostPlatform.isLinux;
    dhcp = stdenv.hostPlatform.isLinux;
    af-alg = stdenv.hostPlatform.isLinux;
    resolve = stdenv.hostPlatform.isLinux;
    scripts = stdenv.hostPlatform.isLinux;
    connmark = stdenv.hostPlatform.isLinux;
    forecast = stdenv.hostPlatform.isLinux;
    kernel-netlink = stdenv.hostPlatform.isLinux;

    aesni = stdenv.hostPlatform.isx86_64;
    rdrand = stdenv.hostPlatform.isx86_64;
    padlock = stdenv.hostPlatform.system == "i686-linux";

    kernel-pfkey = stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isFreeBSD;
    kernel-pfroute = stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isFreeBSD;
    kernel-libipsec = stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isFreeBSD;

    keychain = false; # breaks build
    osx-attr = stdenv.hostPlatform.isDarwin;

    ml = true;
    # Note on curl support: If curl is built with gnutls as its backend, the
    # strongswan curl plugin may break.
    # See https://wiki.strongswan.org/projects/strongswan/wiki/Curl for more info.
    curl = true;
    acert = true;
    pkcs11 = true;
    dnscert = true;
    unbound = true;
    chapoly = true;
    ext-auth = true;
    socket-dynamic = stdenv.hostPlatform.isLinux;

    eap-sim = true;
    eap-sim-file = true;
    eap-sim-pcsc = true;
    eap-simaka-pseudonym = true;
    eap-simaka-reauth = true;
    eap-identity = true;
    eap-md5 = true;
    eap-gtc = true;
    eap-aka = true;
    eap-aka-3gpp = true;
    eap-aka-3gpp2 = true;
    eap-mschapv2 = true;
    eap-tls = true;
    eap-peap = true;
    eap-radius = true;

    xauth-eap = true;
    xauth-pam = stdenv.hostPlatform.isLinux;
    xauth-noauth = true;

    gmp = eap-aka-3gpp2;
  }
  // lib.optionalAttrs enableTNC {
    eap-tnc = true;
    eap-ttls = true;
    eap-dynamic = true;

    tnccs-20 = true;

    tnc-imc = true;
    tnc-imv = true;
    tnc-ifmap = true;

    imc-os = true;
    imv-os = true;
    imc-attestation = true;
    imv-attestation = true;

    aikgen = true;
    tss-trousers = true;

    sqlite = true;
  }
  // lib.optionalAttrs enableTPM2 {
    tpm = true;
    tss-tss2 = true;
  };
in
stdenv.mkDerivation rec {
  pname = "strongswan";
  version = "6.0.2"; # Make sure to also update <nixpkgs/nixos/modules/services/networking/strongswan-swanctl/swanctl-params.nix> when upgrading!

  src = fetchFromGitHub {
    owner = "strongswan";
    repo = "strongswan";
    tag = version;
    hash = "sha256-wjz41gt+Xu4XJkEXRRVl3b3ryEoEtijeqmfVFoRjnA4=";
  };

  patches = [
    ./ext_auth-path.patch
    ./firewall_defaults.patch
    ./updown-path.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    bison
    flex
    perl
    gperf
  ];

  buildInputs =
    lib.optional (features.gmp or false) gmp
    ++ lib.optional (features.eap-sim-pcsc or false) pcsclite
    ++ lib.optional (features.openssl or false) openssl
    ++ lib.optional (features.curl or false) curl
    ++ lib.optional (features.systemd or false) systemd
    ++ lib.optional (features.tnc-ifmap or false) libxml2
    ++ lib.optional (features.xauth-pam or false) pam
    ++ lib.optional (features.forecast or false || features.connmark or false) iptables
    ++ lib.optional (features.tss-trousers or false) trousers
    ++ lib.optional (features.tss-tss2 or false) tpm2-tss
    ++ lib.optional (features.sqlite or false) sqlite
    ++ lib.optionals (features.unbound or false) [
      unbound
      ldns
    ]
    ++ lib.optionals (features.nm or false) [
      networkmanager
      glib
    ];

  configureFlags = (lib.mapAttrsToList (lib.flip lib.enableFeature)) features ++ [
    "--sysconfdir=/etc"
    (lib.withFeatureAs (features.nm or false) "nm-ca-dir" "/etc/ssl/certs")
    (lib.withFeatureAs (features.systemd or false
    ) "systemdsystemunitdir" "${placeholder "out"}/etc/systemd/system")
  ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
  ];

  enableParallelBuilding = true;

  dontPatchELF = true;

  passthru.tests = { inherit (nixosTests) strongswan-swanctl; };

  postPatch = lib.optionalString features.resolve ''
    substituteInPlace src/libcharon/plugins/resolve/resolve_handler.c \
      --replace-fail "/sbin/resolvconf" "${openresolv}/sbin/resolvconf"
  '';

  meta = {
    description = "OpenSource IPsec-based VPN solution";
    homepage = "https://www.strongswan.org/";
    changelog = "https://github.com/strongswan/strongswan/blob/${src.rev}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "swanctl";
    platforms = lib.platforms.unix;
  };
}
