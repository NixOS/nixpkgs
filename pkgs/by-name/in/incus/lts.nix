import ./generic.nix {
  hash = "sha256-LYQ7PFYLjXGqztovhvfJ9XR7xpinPvMvKZgiqsAUvbc=";
  version = "7.0.2";
  vendorHash = "sha256-huplVEZrpV5jI2nXJcmtFeY5SPDBSYwoZ1EtvEUY5Q0=";
  patches = fetchpatch: [
    # incusd/instance/lxc: Reject line breaks in LXC config values
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/e933b9f920e16af8932c30d4565e293675828dc1.patch";
      hash = "sha256-ytJM4vhmmVuMZvoYrjjXuJcXojmyxLiGEt1HKXG8MeY=";
      name = "GHSA-3wxw-5gh2-j2x2.1.patch";
    })
    # incusd/instance/lxc: Only parse config.json for OCI containers
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/084e2d482010fa9b86d20c21312bdeffa8099d31.patch";
      hash = "sha256-IEmcercBGbTsj+7ws2ThDayBlEoH2Y5/f3nSi/QCILw=";
      name = "GHSA-3wxw-5gh2-j2x2.2.patch";
    })
    # incusd/instance/lxc: Keep loader variables out of the forklxc environment
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/e00b75d4ac0393ab46eecd07a7c7abfb697c89f0.patch";
      hash = "sha256-iayuWDj891XOFgVazMblQULCsAPJW9NXh/QOWan6wxM=";
      name = "GHSA-3wxw-5gh2-j2x2.3.patch";
    })
    # incusd/dev_incus: Anchor the cgroup based monitor detection
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/83eaa5e19345a4719df46bcdb2850547d069b88e.patch";
      hash = "sha256-5bCdkiKjIMezelVBzWiMcxgs9TCRsmlhcDjQZwCQ4FA=";
      name = "GHSA-v736-5xp3-jghf.patch";
    })
    # incusd: Check resource creation against the effective project
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/929041ead77a385d7318e001403d36520fb75b93.patch";
      hash = "sha256-MuMCCQMiRBZQQfICAggYNvCk0bpvEMTSmg5WpbpWimk=";
      name = "GHSA-5c64-j5m6-8433.patch";
    })
    # incusd/auth/tls: Restrict inherited reads to the certificate's projects
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/131d0f6dcd755bd52957a1a1d25d7930c844420d.patch";
      hash = "sha256-IknnK/5YMQmrntjYWjAWacpxaZWWYVP4fMPAjTSqxwY=";
      name = "GHSA-8r3h-vc36-6xpx.patch";
    })
    # incusd/operations: Protect token operations from events and cancellation
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/150b8c512f6fc00034b3324406dbf6a4edb3dc52.patch";
      hash = "sha256-07+/mpq9GBLEOIomDVPVNPelAIr43LcS9xMX925jY9I=";
      name = "GHSA-cwg9-8mc4-hf7j.patch";
    })
    # incusd/storage/s3: Verify signed payloads without buffering
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/2b589bc682c9e5c76a2947d9cad993035c503277.patch";
      hash = "sha256-tZz43cqb1vDmR3+KnFYrDvY8SMs5DVViRgH2hOWZy24=";
      name = "GHSA-8mgx-h4v8-xqv2.patch";
    })
    # incusd/storage: Validate dependent volumes received through migration
    (fetchpatch {
      url = "https://salsa.debian.org/go-team/packages/incus/-/raw/380a16d82b8688d45a6693a7cf42fafb9fbba606/debian/patches/104-GHSA-q9fc-p923-6vp7.patch";
      hash = "sha256-MPq38ZQtoVFvGYIsB5ZKdh0ZDsXepJpYQZaQiKDllTk=";
      name = "GHSA-q9fc-p923-6vp7.patch";
    })
    # incusd/storage: Validate snapshot names from the backup index on import
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/f7a97ee92b10e1b2bc3118453e9c0089d2dc17df.patch";
      hash = "sha256-HdjlSa9Y0Gajb4GBc15Wl31m2jxM7Hcm7EC57a9wxXk=";
      name = "GHSA-p45f-gqqj-6qq3.patch";
    })
    # incusd: Only trust the key-proven client certificate
    (fetchpatch {
      url = "https://salsa.debian.org/go-team/packages/incus/-/raw/380a16d82b8688d45a6693a7cf42fafb9fbba606/debian/patches/102a-cherry-pick-CheckTrustStateIssuer.patch";
      hash = "sha256-QLR6mW9gs3TegabKMZErprBhwvNWXsL7sXxYmWlWB2o=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/go-team/packages/incus/-/raw/380a16d82b8688d45a6693a7cf42fafb9fbba606/debian/patches/102b-GHSA-xg75-xf37-cph9.patch";
      hash = "sha256-DQdddXdXnS6U5sjz7zjC8jMwsxa3+Fc+Q5tFKH1QS6k=";
      name = "GHSA-xg75-xf37-cph9.patch";
    })
    # incusd/dev_incus: Pin image export to the instance's project
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/00bb61411e5df26a866288482363e3baf75da563.patch";
      hash = "sha256-hXup/fYYoxM+k5mkTVz0dCAhOAGenXk/FyA/99UGRRc=";
      name = "GHSA-f7xp-22ph-v444.patch";
    })
    # incusd/events: Restrict network-acl events to privileged viewers
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/ed41dec85ffde702bad04270eb9ed844a64acf79.patch";
      hash = "sha256-BDXTIaQrRXkibyjd6ep88/MnPnj/DxMB2yA/faqJwbQ=";
      name = "GHSA-9f75-5fjw-5jvv.patch";
    })
    # incusd/instance/lxc: Allocate an idmap when none is set at start
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/e23bcb8b7e1dd223140668a67907b3312c562f42.patch";
      hash = "sha256-tdBGAcolz6RgdStHU7rVpGqEsQKlUvIofUlObnOa+bg=";
      name = "GHSA-9c46-v3hw-v6m8.patch";
    })
    # incusd: Authorize effective project on resource creation
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/c738b760352413c48c58bd1fbe7bd27ab41c84c1.patch";
      hash = "sha256-tfrSMkjuK+bRIrjPSEWPal4rSA8MZuCWk4Ky7weMYoA=";
      name = "GHSA-jcw9-v2ff-8m79.patch";
    })
    # incusd: Fix cross-project disclosure in recursive and all-projects listings
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/9721b743bc89baebeb3e0a7a2a306c924256a8c7.patch";
      hash = "sha256-sKO8ibBLGL3hUg6uBZNDCt32gWPUdxc7ir/3XY4IQrk=";
      name = "GHSA-pf5w-m8m6-5265.patch";
    })
    # incusd/storage: Strip non-regular files from instance metadata
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/724ab0fee1a85b5f741fe58b3e432c5f6b4ef414.patch";
      hash = "sha256-IQTS1+txrJR/E97rgMOczMDjVA9IbHdZDN/Lp6eWM00=";
      name = "GHSA-5pgx-q9xx-j3qv.patch";
    })
    # incusd/instance/qemu: Confine NBD migration sockets to the run directory
    (fetchpatch {
      url = "https://salsa.debian.org/go-team/packages/incus/-/raw/380a16d82b8688d45a6693a7cf42fafb9fbba606/debian/patches/108a-cherry-pick-helpers.patch";
      hash = "sha256-iDVkR9aw2n9MVdqEuAGFaA8Rf9T4y0DVMmuSbOhpThI=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/go-team/packages/incus/-/raw/380a16d82b8688d45a6693a7cf42fafb9fbba606/debian/patches/108b-GHSA-3rgf-297m-775x.patch";
      hash = "sha256-2CL6Rcos94L1wMQKNobsA84eVJi67rFn8Xu14rfyYdI=";
      name = "GHSA-3rgf-297m-775x.patch";
    })
    # incusd: Reject null snapshot entries on backup import
    (fetchpatch {
      url = "https://github.com/lxc/incus/commit/dcc80425594819ee1978110aa0071453308f6fa9.patch";
      hash = "sha256-xxcYsCB4yMfFvge1m6egLoE378fWm4lJ085fiafbM5c=";
      name = "GHSA-x6pw-mh5w-pq73.patch";
    })
    # incusd/operations: Keep websocket secrets out of events and queries
    (fetchpatch {
      url = "https://salsa.debian.org/go-team/packages/incus/-/raw/380a16d82b8688d45a6693a7cf42fafb9fbba606/debian/patches/110-GHSA-h2j8-4crh-vhfc.patch";
      hash = "sha256-/ob+k/eVhuXvSkkk/sErQhtLhLbMfvr102vquUAK/R0=";
      name = "GHSA-h2j8-4crh-vhfc.patch";
    })
  ];
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex=^v(7\\.0\\.[0-9]+)$"
    "--override-filename=pkgs/by-name/in/incus/lts.nix"
  ];
}
