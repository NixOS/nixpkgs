{
  lib,
  fetchurl,
  stdenv,
  testers,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quickjs";
  version = "2024-01-13";

  src = fetchurl {
    url = "https://bellard.org/quickjs/quickjs-${finalAttrs.version}.tar.xz";
    hash = "sha256-PEv4+JW/pUvrSGyNEhgRJ3Hs/FrDvhA2hR70FWghLgM=";
  };

  outputs = [
    "out"
    "info"
  ];

  nativeBuildInputs = [
    texinfo
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  doInstallCheck = true;

  enableParallelBuilding = true;

  strictDeps = true;

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile \
      --replace "CONFIG_LTO=y" ""
  '';

  postBuild = ''
    pushd doc
    makeinfo *texi
    popd
  '';

  postInstall = ''
    pushd doc
    install -Dm644 -t ''${!outputInfo}/share/info *info
    popd
  '';

  installCheckPhase = lib.concatStringsSep "\n" [
    ''
      runHook preInstallCheck
    ''

    ''
      PATH="$out/bin:$PATH"
    ''
    # Programs exit with code 1 when testing help, so grep for a string
    ''
      set +o pipefail
      qjs     --help 2>&1 | grep "QuickJS version"
      qjscalc --help 2>&1 | grep "QuickJS version"
      set -o pipefail
    ''

    ''
      temp=$(mktemp).js
      echo "console.log('Output from compiled program');" > "$temp"
      set -o verbose
      out=$(mktemp) && qjsc       -o "$out" "$temp" && "$out" | grep -q "Output from compiled program"
      out=$(mktemp) && qjsc -flto -o "$out" "$temp" && "$out" | grep -q "Output from compiled program"
    ''

    ''
      runHook postInstallCheck
    ''
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "qjs --help || true";
    };
  };

  meta = {
    homepage = "https://bellard.org/quickjs/";
    description = "Small and embeddable Javascript engine";
    longDescription = ''
      QuickJS is a small and embeddable Javascript engine. It supports the
      ES2023 specification including modules, asynchronous generators, proxies
      and BigInt.

      It optionally supports mathematical extensions such as big decimal
      floating point numbers (BigDecimal), big binary floating point numbers
      (BigFloat) and operator overloading.

      Main Features:

      - Small and easily embeddable: just a few C files, no external
        dependency, 210 KiB of x86 code for a simple hello world program.
      - Fast interpreter with very low startup time: runs the 76000 tests of
        the ECMAScript Test Suite in less than 2 minutes on a single core of a
        desktop PC. The complete life cycle of a runtime instance completes in
        less than 300 microseconds.
      - Almost complete ES2023 support including modules, asynchronous
        generators and full Annex B support (legacy web compatibility).
      - Passes nearly 100% of the ECMAScript Test Suite tests when selecting
        the ES2023 features. A summary is available at Test262 Report.
      - Can compile Javascript sources to executables with no external dependency.
      - Garbage collection using reference counting (to reduce memory usage and
        have deterministic behavior) with cycle removal.
      - Mathematical extensions: BigDecimal, BigFloat, operator overloading,
        bigint mode, math mode.
      - Command line interpreter with contextual colorization implemented in
        Javascript.
      - Small built-in standard library with C library wrappers.

    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      stesie
      AndersonTorres
    ];
    mainProgram = "qjs";
    platforms = lib.platforms.all;
  };
})
