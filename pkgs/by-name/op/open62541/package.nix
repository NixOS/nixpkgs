{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, check
, libxcrypt
, subunit
, python3Packages
, nix-update-script

, withDoc ? false
, graphviz-nox

, withExamples ? false

, withEncryption ? false # or "openssl" or "mbedtls"
, openssl
, mbedtls

# for passthru.tests only
, open62541
}:

let
  encryptionBackend = {
    inherit openssl mbedtls;
  }."${withEncryption}" or (throw "Unsupported encryption backend: ${withEncryption}");
in

stdenv.mkDerivation (finalAttrs: {
  pname = "open62541";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "open62541";
    repo = "open62541";
    rev = "v${finalAttrs.version}";
    hash = "sha256-An8Yg6VSelNV/7poLEOjeiIb0+eMoQWG7sYqhytEKMA=";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    (lib.cmakeFeature "OPEN62541_VERSION" finalAttrs.src.rev)
    (lib.cmakeFeature "UA_NAMESPACE_ZERO" "FULL")
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))

    # Note comment near doCheck
    (lib.cmakeBool "UA_BUILD_UNIT_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "UA_ENABLE_ALLOW_REUSEADDR" finalAttrs.finalPackage.doCheck)

    (lib.cmakeBool "UA_BUILD_EXAMPLES" withExamples)
  ] ++ lib.optionals (withEncryption != false) [
    (lib.cmakeFeature "UA_ENABLE_ENCRYPTION" (lib.toUpper withEncryption))
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.python
  ] ++ lib.optionals withDoc (with python3Packages; [
    sphinx
    sphinx_rtd_theme
    graphviz-nox
  ]);

  buildInputs = lib.optional (withEncryption != false) encryptionBackend;

  buildFlags = [ "all" ] ++ lib.optional withDoc "doc";

  # Tests must normally be disabled because they require
  # -DUA_ENABLE_ALLOW_REUSEADDR=ON. The option must not be used in production,
  # since it is a security risk.
  # See https://github.com/open62541/open62541/issues/6407
  doCheck = false;

  checkInputs = [
    check
    libxcrypt
    subunit
  ];

  # Tests must run sequentially to avoid port collisions on localhost
  enableParallelChecking = false;

  preCheck = let
    disabledTests = [
      # error "Could not create a raw Ethernet socket (are you root?)"
      "check_eventloop_eth"

      # Cannot set socket option IP_ADD_MEMBERSHIP
      "check_pubsub_publish"
      "check_pubsub_publish_json"
      "check_pubsub_connection_udp"
      "check_pubsub_get_state"
      "check_pubsub_publisherid"
      "check_pubsub_subscribe"
      "check_pubsub_publishspeed"
      "check_pubsub_subscribe_config_freeze"
      "check_pubsub_subscribe_rt_levels"
      "check_pubsub_multiple_subscribe_rt_levels"
      "check_pubsub_config_freeze"
      "check_pubsub_publish_rt_levels"

      # Could not find the interface
      "check_pubsub_connection_ethernet"
      "check_pubsub_connection_ethernet_etf"
      "check_pubsub_publish_ethernet_etf"
      "check_pubsub_informationmodel"
      "check_pubsub_informationmodel_methods"
    ];
    regex = "^(${builtins.concatStringsSep "|" disabledTests})\$";
  in lib.optionalString (disabledTests != []) ''
    checkFlagsArray+=(ARGS="-E ${lib.escapeRegex regex}")
  '';

  postInstall = lib.optionalString withDoc ''
    # excluded files, see doc/CMakeLists.txt
    rm -r doc/{_sources/,CMakeFiles/,cmake_install.cmake}

    # doc is not installed automatically
    mkdir -p $out/share/doc/open62541
    cp -r doc/ $out/share/doc/open62541/html
  '' + lib.optionalString withExamples ''
    # install sources of examples
    mkdir -p $out/share/open62541
    cp -r ../examples $out/share/open62541

    ${lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    # remove .exe suffix
    mv -v $out/bin/ua_server_ctt.exe $out/bin/ua_server_ctt
    ''}

    # remove duplicate libraries in build/bin/, which cause forbidden
    # references to /build/ in ua_server_ctt
    rm -r bin/libopen62541*
  '';

  passthru.updateScript = nix-update-script { };

  passthru.tests = let
    open62541Full = encBackend: (open62541.overrideAttrs (_: {
      doCheck = true;
    })).override {
      withDoc = true;
      # if withExamples, one of the example currently fails to build
      #withExamples = true;
      withEncryption = encBackend;
    };
  in {
    open62541WithTests = finalAttrs.finalPackage.overrideAttrs (_: { doCheck = true; });
    open62541Full = open62541Full false;
    open62541Full-openssl = open62541Full "openssl";
    open62541Full-mbedtls = open62541Full "mbedtls";
  };

  meta = with lib; {
    description = "Open source implementation of OPC UA";
    longDescription = ''
      open62541 (http://open62541.org) is an open source and free implementation
      of OPC UA (OPC Unified Architecture) written in the common subset of the
      C99 and C++98 languages.
      The library is usable with all major compilers and provides the necessary
      tools to implement dedicated OPC UA clients and servers, or to integrate
      OPC UA-based communication into existing applications.
    '';
    homepage = "https://www.open62541.org";
    changelog = "https://github.com/open62541/open62541/releases/tag/v${finalAttrs.version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ panicgh ];
    platforms = platforms.linux;
  };
})
