{ lib, ... }:
lib.makeExtensible (self: {
  toGOOS = platform:
    if platform.isAndroid then "android"
    else if platform.isWasi then "wasip1"
    else if platform.isWasm then "js"
    else platform.parsed.kernel.name;

  toGOARCH = platform:
    if platform.isx86_32 then "386"
    else if platform.isx86_64 then "amd64"
    else if platform.isAarch32 then "arm"
    else if platform.isAarch64 then "arm64"
    else if platform.isLoongArch64 then "loong64"
    else if platform.isMips then
      "mips"
      + lib.optionalString platform.is64bit "64"
      + lib.optionalString platform.isLittleEndian "le"
    else if platform.isPower64 then
      "ppc64" + lib.optionalString platform.isLittleEndian "le"
    # Go does not support 32-bit WASM. See https://go.dev/issue/63131
    else if platform.isWasm && platform.is64bit then "wasm"
    else platform.parsed.cpu.name;

  # Returns Go environment variables to build for the given platform.
  toGoEnv = platform: {
    GOOS = self.toGOOS platform;
    GOARCH = self.toGOARCH platform;
  } // lib.optionalAttrs (platform.isAarch32) {
    GOARM = toString (lib.intersectLists [ (platform.parsed.cpu.version or "") ] [ "5" "6" "7" ]);
  } // (platform.go or { });

  # Allows detecting whether Go will install binaries under ${GOOS}_${GOARCH}
  # subdirectory (that is, whether we are cross-compiling).
  isCross = build: host:
    let
      GOHOSTOS = build.GOOS;
      GOHOSTARCH = build.GOARCH;
      inherit (host) GOOS GOARCH;
    in
    GOHOSTOS != GOOS || GOHOSTARCH != GOARCH;
})
