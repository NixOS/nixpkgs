{
  lib,
  stdenv,
  fetchFromGitHub,
  # Native build inputs
  cmake,
  pkg-config,
  # General build inputs
  glib,
  gtest,
  json_c,
  openldap,
  # Plugin build inputs
  cryptopp,
  davix-copy,
  dcap,
  libssh2,
  libuuid,
  pugixml,
  xrootd,
  # For enablePluginStatus.https only
  gsoap,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gfal2";
  version = "2.23.5";

  src = fetchFromGitHub {
    owner = "cern-fts";
    repo = "gfal2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Dt6xA7U4aPKFZmO2iAiYM99w5ZIZNQJ+JXzuVItIlBM=";
  };

  passthru.enablePluginStatus = {
    # TODO: Change back to `true` once dcap is fixed on Darwin.
    dcap = !dcap.meta.broken;
    file = true;
    gridftp = false;
    # davix-copy's dependency gsoap is currently only available on Linux.
    # TODO: Change back to `true` once gsoap is fixed on Darwin.
    http = lib.meta.availableOn stdenv.hostPlatform gsoap;
    lfc = false;
    # Break because of redundant `-luuid`. This needs to be fixed from the gfal2 upstream.
    # TODO: Change back to `true` once fixed.
    mock = !stdenv.hostPlatform.isDarwin;
    rfio = false;
    sftp = true;
    srm = false;
    xrootd = true;
  };

  passthru.tests =
    (
      # Enable only one plugin in each test case,
      # to ensure that they gets their dependency when invoked separately.
      lib.listToAttrs (
        map
          (
            pluginName:
            lib.nameValuePair "gfal2-${pluginName}" (
              finalAttrs.finalPackage.overrideAttrs (previousAttrs: {
                passthru = previousAttrs.passthru // {
                  enablePluginStatus = lib.mapAttrs (n: v: n == pluginName) previousAttrs.passthru.enablePluginStatus;
                };
              })
            )
          )
          (
            lib.filter (lib.flip lib.getAttr finalAttrs.passthru.enablePluginStatus) (
              lib.attrNames finalAttrs.passthru.enablePluginStatus
            )
          )
      )
    )
    // {
      # Disable all plugins in this test case.
      gfal2-minimal = finalAttrs.finalPackage.overrideAttrs (previousAttrs: {
        passthru.enablePluginStatus = lib.mapAttrs (n: v: false) previousAttrs.passthru.enablePluginStatus;
      });
    };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = lib.unique (
    [
      glib
      json_c
      # gfal2 version older than 2.21.1 fails to see openldap 2.5+
      # and will complain
      # bin/ld: cannot find -lldap_r: No such file or directory
      # See https://github.com/cern-fts/gfal2/blob/aa24462bb67e259e525f26fb5feb97050a8c5c61/RELEASE-NOTES
      openldap
      pugixml # Optional, for MDS Cache.
    ]
    ++ lib.optionals finalAttrs.passthru.enablePluginStatus.dcap [ dcap ]
    ++ lib.optionals finalAttrs.passthru.enablePluginStatus.http [
      cryptopp
      davix-copy
    ]
    ++ lib.optionals finalAttrs.passthru.enablePluginStatus.mock [ libuuid ]
    ++ lib.optionals finalAttrs.passthru.enablePluginStatus.sftp [ libssh2 ]
    ++ lib.optionals finalAttrs.passthru.enablePluginStatus.xrootd [
      xrootd
      libuuid
    ]
  );

  preConfigure =
    let
      cmakeFiles = [
        "CMakeLists.txt"
        "src/CMakeLists.txt"
        "src/core/CMakeLists.txt"
        "src/core/transfer/CMakeLists.txt"
        "src/plugins/CMakeLists.txt"
        "src/plugins/dcap/CMakeLists.txt"
        "src/plugins/file/CMakeLists.txt"
        "src/plugins/gridftp/CMakeLists.txt"
        "src/plugins/http/CMakeLists.txt"
        "src/plugins/lfc/CMakeLists.txt"
        "src/plugins/mock/CMakeLists.txt"
        "src/plugins/rfio/CMakeLists.txt"
        "src/plugins/sftp/CMakeLists.txt"
        "src/plugins/srm/CMakeLists.txt"
        "src/plugins/xrootd/CMakeLists.txt"
        "src/utils/CMakeLists.txt"
        "src/version/CMakeLists.txt"
      ];
    in
    ''
      for f in ${lib.escapeShellArgs cmakeFiles}; do
        substituteInPlace "$f" \
          --replace-fail 'cmake_minimum_required (VERSION 2.6)' \
                         'cmake_minimum_required (VERSION 3.10)'
      done
    '';

  cmakeFlags =
    (map (
      pluginName:
      "-DPLUGIN_${lib.toUpper pluginName}=${
        lib.toUpper (lib.boolToString finalAttrs.passthru.enablePluginStatus.${pluginName})
      }"
    ) (lib.attrNames finalAttrs.passthru.enablePluginStatus))
    ++ [ "-DSKIP_TESTS=${lib.toUpper (lib.boolToString (!finalAttrs.finalPackage.doCheck))}" ]
    ++ lib.optionals finalAttrs.finalPackage.doCheck [ "-DGTEST_INCLUDE_DIR=${gtest.dev}/include" ]
    ++ lib.optionals finalAttrs.passthru.enablePluginStatus.http [
      "-DCRYPTOPP_INCLUDE_DIRS=${cryptopp.dev}/include/cryptopp"
    ]
    ++ lib.optionals finalAttrs.passthru.enablePluginStatus.xrootd [
      "-DXROOTD_INCLUDE_DIR=${xrootd.dev}/include/xrootd"
    ];

  doCheck = stdenv.hostPlatform.isLinux;

  checkInputs = [
    gtest
  ];

  meta = with lib; {
    description = "Multi-protocol data management library by CERN";
    longDescription = ''
      GFAL (Grid File Access Library )
      is a C library providing an abstraction layer of
      the grid storage system complexity.
      The complexity of the grid is hidden from the client side
      behind a simple common POSIX API.
    '';
    homepage = "https://github.com/cern-fts/gfal2";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ ShamrockLee ];
    mainProgram = "gfal2";
  };
})
