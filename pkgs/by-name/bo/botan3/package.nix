{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  pkgsStatic,
  python3,
  docutils,
  bzip2,
  zlib,
  jitterentropy,
  darwin,
  esdm,
  tpm2-tss,
  static ? stdenv.hostPlatform.isStatic, # generates static libraries *only*
  windows,

  # build ESDM RNG plugin
  withEsdm ? false,
  # useful, but have to disable tests for now, as /dev/tpmrm0 is not accessible
  withTpm2 ? false,
  policy ? null,
}:

assert lib.assertOneOf "policy" policy [
  # no explicit policy is given. The defaults by the library are used
  null
  # only allow BSI approved algorithms, FFI and SHAKE for XMSS
  "bsi"
  # only allow NIST approved algorithms in FIPS 140
  "fips140"
  # only allow "modern" algorithms
  "modern"
];

let
  stdenv' = if static then buildPackages.libcxxStdenv else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  version = "3.9.0";
  pname = "botan";

  __structuredAttrs = true;
  enableParallelBuilding = true;
  strictDeps = true;

  outputs = [
    "bin"
    "out"
    "dev"
    "doc"
    "man"
  ];

  src = fetchurl {
    url = "http://botan.randombit.net/releases/Botan-${finalAttrs.version}.tar.xz";
    hash = "sha256-jD8oS1jd1C6OQ+n6hqcSnYfqfD93aoDT2mPsIHIrCIM=";
  };

  nativeBuildInputs = [
    python3
    docutils
  ];

  buildInputs = [
    bzip2
    zlib
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && withTpm2) [
    tpm2-tss
  ]
  ++ lib.optionals (lib.versionAtLeast finalAttrs.version "3.6.0" && !stdenv.hostPlatform.isMinGW) [
    jitterentropy
  ]
  ++
    lib.optionals
      (lib.versionAtLeast finalAttrs.version "3.7.0" && withEsdm && !stdenv.hostPlatform.isMinGW)
      [
        esdm
      ]
  ++ lib.optionals (stdenv.hostPlatform.isMinGW) [
    windows.pthreads
  ];

  buildTargets = [
    "cli"
  ]
  ++ lib.optionals finalAttrs.finalPackage.doCheck [ "tests" ]
  ++ lib.optionals static [ "static" ]
  ++ lib.optionals (!static) [ "shared" ];

  botanConfigureFlags = [
    "--prefix=${placeholder "out"}"
    "--bindir=${placeholder "bin"}/bin"
    "--docdir=${placeholder "doc"}/share/doc"
    "--mandir=${placeholder "man"}/share/man"
    "--no-install-python-module"
    "--build-targets=${lib.concatStringsSep "," finalAttrs.buildTargets}"
    "--with-bzip2"
    "--with-zlib"
    "--with-rst2man"
    "--cpu=${stdenv.hostPlatform.parsed.cpu.name}"
  ]
  ++ lib.optionals stdenv.cc.isClang [
    "--cc=clang"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && withTpm2) [
    "--with-tpm2"
  ]
  ++ lib.optionals (lib.versionAtLeast finalAttrs.version "3.6.0" && !stdenv.hostPlatform.isMinGW) [
    "--enable-modules=jitter_rng"
  ]
  ++
    lib.optionals
      (lib.versionAtLeast finalAttrs.version "3.7.0" && withEsdm && !stdenv.hostPlatform.isMinGW)
      [
        "--enable-modules=esdm_rng"
      ]
  ++ lib.optionals (lib.versionAtLeast finalAttrs.version "3.8.0" && policy != null) [
    "--module-policy=${policy}"
  ]
  ++ lib.optionals (lib.versionAtLeast finalAttrs.version "3.8.0" && policy == "bsi") [
    "--enable-module=ffi"
    "--enable-module=shake"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isMinGW) [
    "--os=mingw"
  ];

  configurePhase = ''
    runHook preConfigure
    python configure.py ''${botanConfigureFlags[@]}
    runHook postConfigure
  '';

  preInstall = ''
    if [ -d src/scripts ]; then
      patchShebangs src/scripts
    fi
  '';

  postInstall = ''
    cd "$out"/lib/pkgconfig
    ln -s botan-*.pc botan.pc || true
  '';

  doCheck = true;

  passthru.tests = {
    static = pkgsStatic.botan3;
  };

  meta = with lib; {
    description = "Cryptographic algorithms library";
    homepage = "https://botan.randombit.net";
    mainProgram = "botan";
    maintainers = with maintainers; [
      raskin
      thillux
      nikstur
    ];
    platforms = platforms.unix ++ platforms.windows;
    license = licenses.bsd2;
  };
})
