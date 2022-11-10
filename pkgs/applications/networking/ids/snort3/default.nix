{ stdenv
, lib
, clangStdenv
, fetchFromGitHub
, cmake
, flex
, bison
, pkg-config
, makeWrapper
, cppcheck # for unit tests
, cpputest # for unit tests
, writeScript
, runCommand
, snort3
, nixosTests

, doCheck ? false # tests fail

# Mandatory dependencies
, hwloc
, libdaq3
, libdnet
, libmnl
, libpcap
, libunwind
, libuuid
, luajit
, openssl
, pcre
, xz
, zlib

# Optional dependencies
, withTcmalloc ? true
, gperftools
, withTscClock ? false # build fails
, withLargePcap ? false
, withHyperscan ? !(stdenv.isAarch64)
, hyperscan
, withFlatbuffers ? true
, flatbuffers
}:

with lib;

let
  pname = "snort3";
  version = "3.1.40.0";

  optionalDeps = [
    { enabled = withTcmalloc; deps = [ gperftools ]; }
    { enabled = withHyperscan; deps = [ hyperscan ]; }
    { enabled = withFlatbuffers; deps = [ flatbuffers ]; }
  ];

in
clangStdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "snort3";
    repo = "snort3";
    rev = version;
    sha256 = "oG6wORRk3QE86Vw+3L66iAm/a3NVmKliEheDmyVI6mI=";
  };

  nativeBuildInputs = [
    cmake
    flex
    bison
    pkg-config
    makeWrapper
    cppcheck
    cpputest
  ];

  buildInputs = [
    hwloc
    libdaq3
    libdnet
    libmnl
    libpcap
    libunwind
    libuuid
    luajit
    openssl
    pcre
    xz
    zlib
  ] ++ concatMap (f: optionals f.enabled f.deps) (filter (f: f ? deps) optionalDeps);

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DENABLE_UNIT_TESTS=ON"
    "-DENABLE_HARDENED_BUILD=ON"
    "-DENABLE_PIE=ON"

    "-DDAQ_INCLUDE_DIR_HINT=${libdaq3}/includes"
    "-DDAQ_LIBRARIES_DIR_HINT=${libdaq3}/lib"

    "-DENABLE_TCMALLOC=${if withTcmalloc then "ON" else "OFF"}"
    "-DENABLE_TSC_CLOCK=${if withTscClock then "ON" else "OFF"}"
    "-DENABLE_LARGE_PCAP=${if withLargePcap then "ON" else "OFF"}"
  ];

  postInstall = ''
    wrapProgram $out/bin/snort \
      --add-flags "--daq-dir ${libdaq3}/lib/daq"
  '';

  inherit doCheck;

  passthru = {
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq common-updater-scripts

      set -euo pipefail

      version=$(curl --silent "https://api.github.com/repos/snort3/snort3/releases/latest" | jq -r .tag_name)
      update-source-version "${pname}" "$version"
    '';
    tests = {
      module = nixosTests.snort3;
      # tests fail
      #unitTests = runCommand "${pname}-unit-tests" { } ''
      #  ${snort3}/bin/snort --catch-test all
      #'';
    };
  };

  meta = {
    description = "Network intrusion prevention and detection system (IDS/IPS)";
    homepage = "https://www.snort.org";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ zzschmidc ];
    platforms = platforms.linux;
  };
}
