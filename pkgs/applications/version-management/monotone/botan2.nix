{
  lib,
  stdenv,
  fetchurl,
  pkgsStatic,
  python3,
  docutils,
  bzip2,
  zlib,
  darwin,
  static ? stdenv.hostPlatform.isStatic, # generates static libraries *only*
  enableForMonotone ? false, # Is it being imported for Monotone use?
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "botan";
  version = "2.19.5";

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
    hash = "sha256-3+6g4KbybWckxK8B2pp7iEh62y2Bunxy/K9S21IsmtQ=";
  };

  nativeBuildInputs = [
    python3
    docutils
  ];

  buildInputs = [
    bzip2
    zlib
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

  meta = with lib; {
    description = "Cryptographic algorithms library";
    homepage = "https://botan.randombit.net";
    mainProgram = "botan";
    maintainers = with maintainers; [
      raskin
    ];
    platforms = platforms.unix;
    license = licenses.bsd2;
    knownVulnerabilities = lib.optional (
      !enableForMonotone
    ) "Botan2 is EOL and its full interface surface contains unpatched vulnerabilities";
  };
})
