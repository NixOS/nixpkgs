{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  nss,
  nspr,
  libkrb5,
  gmp,
  zlib,
  libpcap,
  re2,
  gcc,
  python3Packages,
  perl,
  perlPackages,
  withOpenCL ? true,
  opencl-headers,
  ocl-icd,
  # include non-free ClamAV unrar code
  enableUnfree ? false,
  replaceVars,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "john";
  version = "rolling-2404";

  src = fetchFromGitHub {
    owner = "openwall";
    repo = "john";
    rev = "f9fedd238b0b1d69181c1fef033b85c787e96e57";
    hash = "sha256-XMT5Sbp2XrAnfTHxXyJdw0kA/ZtfOiYrX/flCFLHJ6s=";
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
    nss
    nspr
    libkrb5
    gmp
    zlib
    libpcap
    re2
  ]
  ++ lib.optionals withOpenCL [
    opencl-headers
    ocl-icd
  ];
  nativeBuildInputs = [
    gcc
    python3Packages.wrapPython
    perl
    makeWrapper
  ];
  propagatedBuildInputs =
    # For pcap2john.py
    (with python3Packages; [
      dpkt
      scapy
      lxml
    ])
    ++ (with perlPackages; [
      # For pass_gen.pl
      DigestMD4
      DigestSHA1
      GetoptLong
      # For 7z2john.pl
      CompressRawLzma
      # For sha-dump.pl
      perlldap
    ]);
  # TODO: Get dependencies for radius2john.pl and lion2john-alt.pl

  # gcc -DAC_BUILT -Wall vncpcap2john.o memdbg.o -g    -lpcap -fopenmp -o ../run/vncpcap2john
  # gcc: error: memdbg.o: No such file or directory
  enableParallelBuilding = false;

  postInstall = ''
    mkdir -p "$out/bin" "$out/etc/john" "$out/share/john" "$out/share/doc/john" "$out/share/john/rules" "$out/share/john/opencl" "$out/${perlPackages.perl.libPrefix}"
    find -L ../run -mindepth 1 -maxdepth 1 -type f -executable \
      -exec cp -d {} "$out/bin" \;
    cp -vt "$out/etc/john" ../run/*.conf
    cp -vt "$out/share/john" ../run/*.chr ../run/password.lst
    cp -vt "$out/share/john/rules" ../run/rules/*.rule
    cp -vt "$out/share/john/opencl" ../run/opencl/*.cl ../run/opencl/*.h
    cp -vLrt "$out/share/doc/john" ../doc/*
    cp -vt "$out/${perlPackages.perl.libPrefix}" ../run/lib/*
  '';

  postFixup = ''
    wrapPythonPrograms

    for i in $out/bin/*.pl; do
      wrapProgram "$i" --prefix PERL5LIB : "$PERL5LIB:$out/${perlPackages.perl.libPrefix}"
    done
  '';

  meta = {
    description = "John the Ripper password cracker";
    license = [
      lib.licenses.gpl2Plus
    ]
    ++ lib.optionals enableUnfree [ lib.licenses.unfreeRedistributable ];
    homepage = "https://github.com/openwall/john/";
    maintainers = with lib.maintainers; [
      offline
      matthewbauer
      cherrykitten
    ];
    platforms = lib.platforms.unix;
  };
}
