{
  lib,
  llvmPackages,
  fetchFromGitHub,
  cmake,
  ninja,
  bison,
  flex,
  libarchive,
  pam,
  unixODBC,
  jsoncons,
  curl,
  systemdLibs,
  openssl,
  boost183,
  nlohmann_json,
  nanodbc,
  fmt,
  spdlog,
}:

llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "irods";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "irods";
    repo = "irods";
    tag = finalAttrs.version;
    hash = "sha256-gYwuXWRf5MZv3CTUq/RDlU9Ekbw4jZJmSgWRBKqdKJo=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    bison
    flex
  ];

  buildInputs = [
    libarchive
    pam
    unixODBC
    jsoncons
    curl
    systemdLibs
  ];

  propagatedBuildInputs = [
    openssl
    # Can potentially be unpinned after:
    # <https://github.com/irods/irods/issues/7248>
    boost183
    nlohmann_json
    nanodbc
    fmt
    spdlog
  ];

  cmakeFlags = finalAttrs.passthru.commonCmakeFlags ++ [
    # Tracking issues for moving these to `find_package`:
    # * <https://github.com/irods/irods/issues/6249>
    # * <https://github.com/irods/irods/issues/6253>
    (lib.cmakeFeature "IRODS_EXTERNALS_FULLPATH_BOOST" "${boost183}")
    (lib.cmakeFeature "IRODS_EXTERNALS_FULLPATH_NANODBC" "${nanodbc}")
    (lib.cmakeFeature "IRODS_EXTERNALS_FULLPATH_JSONCONS" "${jsoncons}")
  ];

  postPatch = ''
    patchShebangs ./test
    substituteInPlace plugins/database/CMakeLists.txt --replace-fail \
      'COMMAND cpp -E -P -D''${plugin} "''${CMAKE_CURRENT_BINARY_DIR}/src/icatSysTables.sql.pp" ' \
      'COMMAND cpp -E -P -D''${plugin} "''${CMAKE_CURRENT_BINARY_DIR}/src/icatSysTables.sql.pp" -o '
    substituteInPlace server/auth/CMakeLists.txt --replace-fail SETUID ""
  '';

  passthru = {
    commonCmakeFlags = [
      # We already use Clang in the `stdenv`.
      (lib.cmakeBool "IRODS_BUILD_WITH_CLANG" false)
      # Upstream builds with LLVM 16 and doesn’t handle newer warnings.
      (lib.cmakeBool "IRODS_BUILD_WITH_WERROR" false)
      (lib.cmakeFeature "IRODS_HOME_DIRECTORY" "${placeholder "out"}")
      (lib.cmakeFeature "IRODS_LINUX_DISTRIBUTION_NAME" "NixOS")
      (lib.cmakeFeature "IRODS_LINUX_DISTRIBUTION_VERSION" lib.trivial.release)
      (lib.cmakeFeature "IRODS_LINUX_DISTRIBUTION_VERSION_MAJOR" lib.trivial.release)
      (lib.cmakeFeature "CPACK_GENERATOR" "TGZ")
    ];
  };

  meta = {
    description = "Integrated Rule-Oriented Data System (iRODS)";
    longDescription = ''
      The Integrated Rule-Oriented Data System (iRODS) is open source data management
      software used by research organizations and government agencies worldwide.
      iRODS is released as a production-level distribution aimed at deployment in mission
      critical environments.  It virtualizes data storage resources, so users can take
      control of their data, regardless of where and on what device the data is stored.
      As data volumes grow and data services become more complex, iRODS is increasingly
      important in data management. The development infrastructure supports exhaustive
      testing on supported platforms; plug-in support for microservices, storage resources,
      drivers, and databases; and extensive documentation, training and support services.
    '';
    homepage = "https://irods.org";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.linux;
    mainProgram = "irodsServer";
  };
})
