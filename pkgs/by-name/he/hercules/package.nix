{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  libtool,
  cmake,
  zlib,
  bzip2,
  enableRexx ? stdenv.hostPlatform.isLinux,
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
      rev = "9ac58405c2b91fb7cd230aed474dc7059f0fcad9";
      hash = "sha256-hWNowhKP26+HMIL4facOCrZAJ1bR0rRTRc+2R9AM2cc=";
    };
  });

  decNumber = mkExtPkg "decNumber" (default: {
    version = "3.68.0";
    src = fetchFromGitHub {
      owner = "SDL-Hercules-390";
      repo = "decNumber";
      rev = "995184583107625015bb450228a5f3fb781d9502";
      hash = "sha256-3PAJ+HZasf3fr6F1cmqIk+Jjv3Gzkki7AFrAHBaEATo=";
    };
  });

  softFloat = mkExtPkg "SoftFloat" (default: {
    version = "3.5.0";
    src = fetchFromGitHub {
      owner = "SDL-Hercules-390";
      repo = "SoftFloat";
      rev = "e053494d988ec0648c92f683abce52597bfae745";
      hash = "sha256-1UCRYzf24U3zniKnatPvYKSmTEsx3YCrtv1tBR5lvw8=";
    };
  });

  telnet = mkExtPkg "telnet" (default: {
    version = "1.0.0";
    src = fetchFromGitHub {
      owner = "SDL-Hercules-390";
      repo = "telnet";
      rev = "384b2542dfc9af67ca078e2bc13487a8fc234a3f";
      hash = "sha256-dPgLK7nsRZsqY4fVMdlcSHKC2xkGdNmayyK2FW5CNiI=";
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
  version = "4.8";

  src = fetchFromGitHub {
    owner = "SDL-Hercules-390";
    repo = "hyperion";
    rev = "Release_${version}";
    hash = "sha256-3Go5m4/K8d4Vu7Yi8ULQpX83d44fu9XzmG/gClWeUKo=";
  };

  postPatch = ''
    patchShebangs _dynamic_version
  '';

  nativeBuildInputs = [ libtool ];
  buildInputs = [
    (lib.getOutput "lib" libtool)
    zlib
    bzip2
    extpkgs
  ]
  ++ lib.optionals enableRexx [
    regina
  ];

  configureFlags = [
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
