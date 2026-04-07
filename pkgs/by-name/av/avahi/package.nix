{
  fetchurl,
  fetchpatch,
  lib,
  config,
  stdenv,
  pkg-config,
  libdaemon,
  dbus,
  libpcap,
  expat,
  gettext,
  glib,
  autoreconfHook,
  libiconv,
  libevent,
  nixosTests,
  gtk3Support ? false,
  gtk3,
  qt5,
  qt5Support ? false,
  withLibdnssdCompat ? false,
  python ? null,
  withPython ? false,
}:

stdenv.mkDerivation rec {
  pname = "avahi${lib.optionalString withLibdnssdCompat "-compat"}";
  version = "0.8";

  src = fetchurl {
    url = "https://github.com/lathiat/avahi/releases/download/v${version}/avahi-${version}.tar.gz";
    sha256 = "1npdixwxxn3s9q1f365x9n9rc5xgfz39hxf23faqvlrklgbhj0q6";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  patches = [
    # CVE-2021-36217 / CVE-2021-3502
    (fetchpatch {
      name = "CVE-2021-3502.patch";
      url = "https://github.com/lathiat/avahi/commit/9d31939e55280a733d930b15ac9e4dda4497680c.patch";
      sha256 = "sha256-BXWmrLWUvDxKPoIPRFBpMS3T4gijRw0J+rndp6iDybU=";
    })
    # CVE-2021-3468
    (fetchpatch {
      name = "CVE-2021-3468.patch";
      url = "https://github.com/lathiat/avahi/commit/447affe29991ee99c6b9732fc5f2c1048a611d3b.patch";
      sha256 = "sha256-qWaCU1ZkCg2PmijNto7t8E3pYRN/36/9FrG8okd6Gu8=";
    })
    (fetchpatch {
      name = "CVE-2023-1981.patch";
      url = "https://github.com/lathiat/avahi/commit/a2696da2f2c50ac43b6c4903f72290d5c3fa9f6f.patch";
      sha256 = "sha256-BEYFGCnQngp+OpiKIY/oaKygX7isAnxJpUPCUvg+efc=";
    })
    # CVE-2023-38470
    # https://github.com/lathiat/avahi/pull/457 merged Sep 19
    (fetchpatch {
      name = "CVE-2023-38470.patch";
      url = "https://github.com/lathiat/avahi/commit/94cb6489114636940ac683515417990b55b5d66c.patch";
      sha256 = "sha256-Fanh9bvz+uknr5pAmltqijuUAZIG39JR2Lyq5zGKJ58=";
    })
    # https://github.com/avahi/avahi/pull/480 merged Sept 19
    (fetchpatch {
      name = "bail-out-unless-escaped-labels-fit.patch";
      url = "https://github.com/avahi/avahi/commit/20dec84b2480821704258bc908e7b2bd2e883b24.patch";
      sha256 = "sha256-p/dOuQ/GInIcUwuFhQR3mGc5YBL5J8ho+1gvzcqEN0c=";
    })
    # CVE-2023-38473
    # https://github.com/lathiat/avahi/pull/486 merged Oct 18
    (fetchpatch {
      name = "CVE-2023-38473.patch";
      url = "https://github.com/lathiat/avahi/commit/b448c9f771bada14ae8de175695a9729f8646797.patch";
      sha256 = "sha256-/ZVhsBkf70vjDWWG5KXxvGXIpLOZUXdRkn3413iSlnI=";
    })
    # CVE-2023-38472
    # https://github.com/lathiat/avahi/pull/490 merged Oct 19
    (fetchpatch {
      name = "CVE-2023-38472.patch";
      url = "https://github.com/lathiat/avahi/commit/b024ae5749f4aeba03478e6391687c3c9c8dee40.patch";
      sha256 = "sha256-FjR8fmhevgdxR9JQ5iBLFXK0ILp2OZQ8Oo9IKjefCqk=";
    })
    # CVE-2023-38471
    # https://github.com/lathiat/avahi/pull/494 merged Oct 24
    (fetchpatch {
      name = "CVE-2023-38471.patch";
      url = "https://github.com/lathiat/avahi/commit/894f085f402e023a98cbb6f5a3d117bd88d93b09.patch";
      sha256 = "sha256-4dG+5ZHDa+A4/CszYS8uXWlpmA89m7/jhbZ7rheMs7U=";
    })
    # https://github.com/lathiat/avahi/pull/499 merged Oct 25
    (fetchpatch {
      name = "CVE-2023-38471-2.patch";
      url = "https://github.com/avahi/avahi/commit/b675f70739f404342f7f78635d6e2dcd85a13460.patch";
      sha256 = "sha256-uDtMPWuz1lsu7n0Co/Gpyh369miQ6GWGyC0UPQB/yI8=";
    })
    # CVE-2023-38469
    # https://github.com/lathiat/avahi/pull/500 merged Oct 25
    (fetchpatch {
      name = "CVE-2023-38469.patch";
      url = "https://github.com/avahi/avahi/commit/61b9874ff91dd20a12483db07df29fe7f35db77f.patch";
      sha256 = "sha256-qR7scfQqhRGxg2n4HQsxVxCLkXbwZi+PlYxrOSEPsL0=";
      excludes = [ ".github/workflows/smoke-tests.sh" ];
    })
    # https://github.com/avahi/avahi/pull/515 merged Nov 3
    (fetchpatch {
      name = "fix-compare-rrs-with-zero-length-rdata.patch";
      url = "https://github.com/avahi/avahi/commit/177d75e8c43be45a8383d794ce4084dd5d600a9e.patch";
      sha256 = "sha256-uwIyruAWgiWt0yakRrvMdYjjhEhUk5cIGKt6twyXbHw=";
    })
    # https://github.com/avahi/avahi/pull/519 merged Nov 8
    (fetchpatch {
      name = "reject-non-utf-8-service-names.patch";
      url = "https://github.com/avahi/avahi/commit/2b6d3e99579e3b6e9619708fad8ad8e07ada8218.patch";
      sha256 = "sha256-lwSA3eEQgH0g51r0i9/HJMJPRXrhQnTIEDxcYqUuLdI=";
      excludes = [ "fuzz/fuzz-domain.c" ];
    })
    # https://github.com/avahi/avahi/pull/523 merged Nov 12
    (fetchpatch {
      name = "core-no-longer-supply-bogus-services-to-callbacks.patch";
      url = "https://github.com/avahi/avahi/commit/93b14365c1c1e04efd1a890e8caa01a2a514bfd8.patch";
      sha256 = "sha256-VBm8vsBZkTbbWAK8FI71SL89lZuYd1yFNoB5o+FvlEU=";
      excludes = [
        ".github/workflows/smoke-tests.sh"
        "fuzz/fuzz-packet.c"
      ];
    })
    # https://github.com/avahi/avahi/pull/659 merged Nov 19
    (fetchpatch {
      name = "CVE-2024-52616.patch";
      url = "https://github.com/avahi/avahi/commit/f8710bdc8b29ee1176fe3bfaeabebbda1b7a79f7.patch";
      hash = "sha256-BUQOQ4evKLBzV5UV8xW8XL38qk1rg6MJ/vcT5NBckfA=";
    })
    # https://github.com/avahi/avahi/pull/265 merged Mar 3, 2020
    (fetchpatch {
      name = "fix-requires-in-pc-file.patch";
      url = "https://github.com/avahi/avahi/commit/366e3798bdbd6b7bf24e59379f4a9a51af575ce9.patch";
      hash = "sha256-9AdhtzrimmcpMmeyiFcjmDfG5nqr/S8cxWTaM1mzCWA=";
    })
    # https://github.com/avahi/avahi/pull/662 merged 2025-06-19
    # NOTE: CVE-2024-52615 is mitigated by the default NixOS configuration.
    # NOTE: CVE-2025-59529 is introduced by 4e2e1ea0908d7e6ad7f38ae04fdcdf2411f8b942.
    /*
      (fetchpatch {
        name = "CVE-2024-52615.patch"; # AKA GHSA-x6vp-f33h-h32g
        url = "https://github.com/avahi/avahi/commit/4e2e1ea0908d7e6ad7f38ae04fdcdf2411f8b942.patch";
        hash = "sha256-rW6jmKg9oH44rRZow0zE4z6lfTlD8wpFUC8DaI/gruA=";
      })
    */
    # https://github.com/avahi/avahi/pull/806 merged 2025-12-17
    (fetchpatch {
      name = "CVE-2025-68276.patch"; # AKA GHSA-mhf3-865v-g5rc
      url = "https://github.com/avahi/avahi/commit/0c013e2e819be3bda74cecf48b5f64956cf8a760.patch";
      hash = "sha256-kNOwl2DC2FR7CFvPQBBEYaSUSbFnR/ETH9JNGMwzzLE=";
    })
    (fetchpatch {
      name = "CVE-2025-68468.patch"; # AKA GHSA-cp79-r4x9-vf52
      url = "https://github.com/avahi/avahi/commit/f66be13d7f31a3ef806d226bf8b67240179d309a.patch";
      hash = "sha256-HkbKSN2LYqPfVnij1/n6ToN4vKugex3ZPxjHz6pN8eA=";
    })
    (fetchpatch {
      name = "CVE-2025-68471.patch"; # AKA GHSA-56rf-42xr-qmmg
      url = "https://github.com/avahi/avahi/commit/9c6eb53bf2e290aed84b1f207e3ce35c54cc0aa1.patch";
      hash = "sha256-V0OiC0UkZXhUnOUcrPZ+Xvph7MJMQ9DEXgVafoshSi4=";
    })
    (fetchpatch {
      name = "CVE-2026-24401.patch"; # AKA GHSA-h4vp-5m8j-f6w3
      url = "https://github.com/avahi/avahi/commit/78eab31128479f06e30beb8c1cbf99dd921e2524.patch";
      hash = "sha256-Iq7ghHS8gTJ5OeD6Bemis+wPJzKXb2P44qbtTaAaWZI=";
    })
    # https://github.com/avahi/avahi/pull/891 merged 2026-04-01
    (fetchpatch {
      name = "CVE-2026-34933.patch"; # AKA GHSA-w65r-6gxh-vhvc
      url = "https://github.com/avahi/avahi/compare/0ccadca425af151ebb67f276e5cc88e50266a8e6%5E%5E...0ccadca425af151ebb67f276e5cc88e50266a8e6.patch";
      hash = "sha256-yi40iuQmTAW+nLsOIJhh7kg4vG/lqT/PCaSEBPfF2mw=";
    })

  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    glib
    autoreconfHook
  ];

  buildInputs = [
    libdaemon
    dbus
    glib
    expat
    libiconv
    libevent
  ]
  ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
    libpcap
  ]
  ++ lib.optionals gtk3Support [
    gtk3
  ]
  ++ lib.optionals qt5Support [
    qt5
  ];

  propagatedBuildInputs = lib.optionals withPython (
    with python.pkgs;
    [
      python
      pygobject3
      dbus-python
    ]
  );

  configureFlags = [
    "--disable-gdbm"
    "--disable-mono"
    # Use non-deprecated path https://github.com/lathiat/avahi/pull/376
    "--with-dbus-sys=${placeholder "out"}/share/dbus-1/system.d"
    (lib.enableFeature gtk3Support "gtk3")
    (lib.enableFeature qt5Support "qt5")
    (lib.enableFeature withPython "python")
    "--localstatedir=/var"
    "--runstatedir=/run"
    "--sysconfdir=/etc"
    "--with-distro=${with stdenv.hostPlatform; if isBSD then parsed.kernel.name else "none"}"
    # A systemd unit is provided by the avahi-daemon NixOS module
    "--with-systemdsystemunitdir=no"
  ]
  ++ lib.optionals withLibdnssdCompat [
    "--enable-compat-libdns_sd"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # autoipd won't build on darwin
    "--disable-autoipd"
  ];

  installFlags = [
    # Override directories to install into the package.
    # Replace with runstatedir once is merged https://github.com/lathiat/avahi/pull/377
    "avahi_runtime_dir=${placeholder "out"}/run"
    "sysconfdir=${placeholder "out"}/etc"
  ];

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i '20 i\
    #define __APPLE_USE_RFC_2292' \
    avahi-core/socket.c
  '';

  postInstall =
    # Maintain compat for mdnsresponder
    lib.optionalString withLibdnssdCompat ''
      ln -s avahi-compat-libdns_sd/dns_sd.h "$dev/include/dns_sd.h"
    '';

  passthru.tests = {
    smoke-test = nixosTests.avahi;
    smoke-test-resolved = nixosTests.avahi-with-resolved;
  };

  meta = {
    description = "mDNS/DNS-SD implementation";
    homepage = "http://avahi.org";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [
    ];

    longDescription = ''
      Avahi is a system which facilitates service discovery on a local
      network.  It is an implementation of the mDNS (for "Multicast
      DNS") and DNS-SD (for "DNS-Based Service Discovery")
      protocols.
    '';

    knownVulnerabilities = [
      # NOTE: CVE-2024-52615 mitigated by the default NixOS configuration.
      # "CVE-2024-52615: Avahi Wide-Area DNS Uses Constant Source Port"
    ];
  };
}
