{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  openssl,
  gmp,
  zlib,
  libpcap,
  python3,
  perl,
  withOpenCL ? true,
  opencl-headers,
  ocl-icd,
  # include non-free ClamAV unrar code
  enableUnfree ? false,
  replaceVars,
}:

stdenv.mkDerivation {
  pname = "john";
  version = "1.9.0-Jumbo-1-unstable-2026-06-07";

  src = fetchFromGitHub {
    owner = "openwall";
    repo = "john";
    rev = "309326510e585c7a1340dab2e475c2ebfa6295aa";
    hash = "sha256-9bk5Icnm7PgQdSVrAKWHaKN0POctVKbofR7Aa9T2fXE=";
  };

  patches = lib.optionals withOpenCL [
    (replaceVars ./opencl.patch {
      ocl_icd = ocl-icd;
    })
  ];

  postPatch = ''
    sed -ri -e '
      s!^(#define\s+CFG_[A-Z]+_NAME\s+).*/!\1"'"$out"'/etc/john/!
      /^#define\s+JOHN_SYSTEMWIDE/s!/usr!'"$out"'!
    ' src/params.h
    sed -ri -e '/^\.include/ {
      s!\$JOHN!'"$out"'/etc/john!
      s!^(\.include\s*)<([^./]+\.conf)>!\1"'"$out"'/etc/john/\2"!
    }' run/*.conf
  '';

  preConfigure = ''
    cd src
    # Makefile.in depends on AS and LD being set to CC, which is set by default in configure.ac.
    # This ensures we override the environment variables set in cc-wrapper/setup-hook.sh
    export AS=$CC
    export LD=$CC
  ''
  + lib.optionalString withOpenCL ''
    python ./opencl_generate_dynamic_loader.py  # Update opencl_dynamic_loader.c
  '';
  configureFlags = [
    "--disable-native-tests"
    "--with-systemwide"
  ]
  ++ lib.optionals (!enableUnfree) [ "--without-unrar" ];

  buildInputs = [
    openssl
    gmp
    zlib
    libpcap
  ]
  ++ lib.optionals withOpenCL [
    opencl-headers
    ocl-icd
  ];
  nativeBuildInputs = [
    python3 # for opencl_generate_dynamic_loader.py
    perl # detected by configure; gates the crypt(3) format
  ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p "$out/bin" "$out/etc/john" "$out/share/john" "$out/share/doc/john" "$out/share/john/rules" "$out/share/john/opencl"
    # Install the john binary and the compiled C *2john helpers only. The
    # interpreted *.py / *.pl conversion scripts are shipped separately in the
    # `john-data` package, since they pull in a large python/perl closure.
    find -L ../run -mindepth 1 -maxdepth 1 -type f -executable \
      ! -name '*.py' ! -name '*.pl' \
      -exec cp -d {} "$out/bin" \;
    cp -vt "$out/etc/john" ../run/*.conf
    cp -vt "$out/share/john" ../run/*.chr ../run/password.lst
    cp -vt "$out/share/john/rules" ../run/rules/*.rule
    cp -vt "$out/share/john/opencl" ../run/opencl/*.cl ../run/opencl/*.h
    cp -vLrt "$out/share/doc/john" ../doc/*
    # john.conf has `.include <rules/foo.rule>` resolved against
    # $out/etc/john; the actual rule files live under share/john.
    ln -s "$out/share/john/rules" "$out/etc/john/rules"
  '';

  passthru.updateScript = unstableGitUpdater {
    tagFormat = "[0-9].*";
  };

  meta = {
    description = "John the Ripper password cracker";
    license = [
      lib.licenses.gpl2Plus
    ]
    ++ lib.optionals enableUnfree [ lib.licenses.unfreeRedistributable ];
    homepage = "https://github.com/openwall/john/";
    maintainers = with lib.maintainers; [
      cherrykitten
      therealhammer
      mag1cbyt3s
    ];
    platforms = lib.platforms.unix;
  };
}
