{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  libtool,
  cmake,
  zlib,
  bzip2,
  enableRexx ? stdenv.isLinux,
  regina,
}:
let
  herculesCpu = if stdenv.hostPlatform.isx86 then "x86" else stdenv.hostPlatform.qemuArch;
  herculesBits = if stdenv.hostPlatform.is32bit then "32" else "64";

  herculesLibDir = if stdenv.hostPlatform.isx86 then "lib" else "lib/${herculesCpu}";

  mkExtPkg =
    depName: attrFn:
    (stdenv.mkDerivation {
      pname = "hercules-${depName}";

      postPatch = ''
        patchShebangs build
        sed -i build \
          -e "s%_tool=.*$%_tool=${cmake}/bin/cmake%" \
          -e "s/CPUS=.*$/CPUS=$NIX_BUILD_CORES/"
      '';

      dontUseCmakeConfigure = true;

      buildPhase = ''
        mkdir ../build $out
        # In source builds are not allowed.
        cd ../build
        ../source/build \
          --pkgname ${depName} \
          --cpu ${herculesCpu} \
          --arch ${herculesBits} \
          --install "$out"
      '';

      nativeBuildInputs = [ cmake ];

      enableParallelBuilding = true;

      meta = with lib; {
        description = "Hercules ${depName} library";
        license = lib.licenses.free; # Mixture of Public Domain, ICU (MIT compatible) and others
        maintainers = with maintainers; [
          anna328p
          vifino
        ];
      };
    }).overrideAttrs
      (default: attrFn default);

  crypto = mkExtPkg "crypto" (default: {
    version = "1.0.0";
    src = fetchFromGitHub {
      owner = "SDL-Hercules-390";
      repo = "crypto";
      rev = "a5096e5dd79f46b568806240c0824cd8cb2fcda2";
      hash = "sha256-VWjM8WxPMynyW49Z8U/r6SsF7u7Xbk7Dd0gR35lIw28=";
    };
  });

  decNumber = mkExtPkg "decNumber" (default: {
    version = "3.68.0";
    src = fetchFromGitHub {
      owner = "SDL-Hercules-390";
      repo = "decNumber";
      rev = "3aa2f4531b5fcbd0478ecbaf72ccc47079c67280";
      hash = "sha256-PfPhnYUSIw1sYiGRM3iHRTbHHbQ+sK7oO12pH/yt+MQ=";
    };
  });

  softFloat = mkExtPkg "SoftFloat" (default: {
    version = "3.5.0";
    src = fetchFromGitHub {
      owner = "SDL-Hercules-390";
      repo = "SoftFloat";
      rev = "4b0c326008e174610969c92e69178939ed80653d";
      hash = "sha256-DEIT5Xk6IqUXCIGD2Wj0h9xPOR0Mid2Das7aKMQMDaM=";
    };
  });

  telnet = mkExtPkg "telnet" (default: {
    version = "1.0.0";
    src = fetchFromGitHub {
      owner = "SDL-Hercules-390";
      repo = "telnet";
      rev = "729f0b688c1426018112c1e509f207fb5f266efa";
      hash = "sha256-ED0Cl+VcK6yl59ShgJBZKy25oAFC8eji36pNLwMxTM0=";
    };
  });

  extpkgs = runCommand "hercules-extpkgs" { } ''
    OUTINC="$out/include"
    OUTLIB="$out/${herculesLibDir}"
    mkdir -p "$OUTINC" "$OUTLIB"
    for dep in "${crypto}" "${decNumber}" "${softFloat}" "${telnet}"; do
      ln -s $dep/include/* "$OUTINC"
      ln -s $dep/${herculesLibDir}/* "$OUTLIB"
    done
  '';
in
stdenv.mkDerivation rec {
  pname = "hercules";
  version = "4.6";

  src = fetchFromGitHub {
    owner = "SDL-Hercules-390";
    repo = "hyperion";
    rev = "Release_${version}";
    hash = "sha256-ZhMTun6tmTsmIiFPTRFudwRXzWydrih61RsLyv0p24U=";
  };

  postPatch = ''
    patchShebangs _dynamic_version
  '';

  nativeBuildInputs = [ libtool ];
  buildInputs =
    [
      (lib.getOutput "lib" libtool)
      zlib
      bzip2
      extpkgs
    ]
    ++ lib.optionals enableRexx [
      regina
    ];

  configureFlags =
    [
      "--enable-extpkgs=${extpkgs}"
      "--without-included-ltdl"
      "--enable-ipv6"
      "--enable-cckd-bzip2"
      "--enable-het-bzip2"
    ]
    ++ lib.optionals enableRexx [
      "--enable-regina-rexx"
    ];

  meta = with lib; {
    homepage = "https://sdl-hercules-390.github.io/html/";
    description = "IBM mainframe emulator";
    longDescription = ''
      Hercules is an open source software implementation of the mainframe
      System/370 and ESA/390 architectures, in addition to the latest 64-bit
      z/Architecture. Hercules runs under Linux, Windows, Solaris, FreeBSD, and
      Mac OS X.
    '';
    license = licenses.qpl;
    maintainers = with maintainers; [
      anna328p
      vifino
    ];
  };
}
