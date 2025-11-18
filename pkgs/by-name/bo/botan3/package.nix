{
  lib,
  stdenv,
  libcxxStdenv,
  fetchurl,
  pkgsStatic,
  runCommandLocal,
  binutils,
  python3,
  docutils,
  bzip2,
  zlib,
  jitterentropy,
  esdm,
  tpm2-tss,
  static ? stdenv.hostPlatform.isStatic,
  windows,

  # build ESDM RNG plugin
  withEsdm ? false,
  # useful, but have to disable tests for now, as /dev/tpmrm0 is not accessible
  withTpm2 ? false,
  policy ? null,
  # create additional "selftests" output and put botan-test binary together with
  # test vectors there. Useful to perform initial botan self-tests before using it
  exposeSelftests ? false,
}@args:

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
  stdenv = if static then libcxxStdenv else args.stdenv;

  # (based on same workaround from capnproto package)
  #
  # HACK: work around https://github.com/NixOS/nixpkgs/issues/177129
  # Though this is an issue between Clang and GCC,
  # so it may not get fixed anytime soon...
  empty-libgcc_eh =
    runCommandLocal "empty-libgcc_eh"
      {
        nativeBuildInputs = [ binutils ];
      }
      ''
        mkdir -p "$out"/lib
        ${stdenv.cc.targetPrefix}ar r "$out"/lib/libgcc_eh.a
      '';
in
stdenv.mkDerivation (finalAttrs: {
  version = "3.10.0";
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
  ]
  ++ lib.optionals exposeSelftests [
    "selftests"
  ];

  src = fetchurl {
    url = "http://botan.randombit.net/releases/Botan-${finalAttrs.version}.tar.xz";
    hash = "sha256-/eGUI29tVDTxNuoKBif2zJ0mr4uW6fHhx9jILNkPTyQ=";
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

  propagatedBuildInputs = lib.optional static empty-libgcc_eh;

  buildTargets = [
    "cli"
  ]
  ++ lib.optionals (finalAttrs.finalPackage.doCheck || exposeSelftests) [ "tests" ]
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

  postInstall =
    lib.optionalString exposeSelftests ''
      mkdir -p $selftests/bin
      install -Dpm755 -D botan-test $selftests/bin/botan-test

      # don't copy leading source folder structure
      pushd src/tests/data &> /dev/null
      find . -type d -exec install -d $selftests/test-data/{} \;
      find . -type f -exec install -Dpm644 {} $selftests/test-data/{} \;
      popd &> /dev/null
    ''
    + ''
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
