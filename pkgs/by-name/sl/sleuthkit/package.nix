{
  lib,
  stdenv,
  fetchFromGitHub,
<<<<<<< HEAD
  fetchpatch,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  autoreconfHook,
  ant,
  jdk,
  perl,
  stripJavaArchivesHook,
  afflib,
  libewf,
  openssl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sleuthkit";
<<<<<<< HEAD
  version = "4.14.0"; # Note: when updating don't forget to also update the rdeps outputHash
=======
  version = "4.12.1"; # Note: when updating don't forget to also update the rdeps outputHash
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "sleuthkit";
    repo = "sleuthkit";
    rev = "sleuthkit-${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-WvGVEDuhpmcyPOaihDruBbQbcj7s+Zkt2/D5CIsu0u8=";
=======
    hash = "sha256-q51UY2lIcLijycNaq9oQIwUXpp/1mfc3oPN4syOPF44=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Fetch libraries using a fixed output derivation
  rdeps = stdenv.mkDerivation {
    name = "sleuthkit-${finalAttrs.version}-deps";
    inherit (finalAttrs) src;

    nativeBuildInputs = [
      ant
      jdk
    ];

    # unpack, build, install
    dontConfigure = true;

    buildPhase = ''
      export IVY_HOME=$NIX_BUILD_TOP/.ant
      pushd bindings/java
      ant retrieve-deps
      popd
      pushd case-uco/java
      ant get-ivy-dependencies
      popd
    '';

    installPhase = ''
      mkdir -m 755 -p $out/bindings/java
      cp -r bindings/java/lib $out/bindings/java
      mkdir -m 755 -p $out/case-uco/java
      cp -r case-uco/java/lib $out/case-uco/java
      cp -r $IVY_HOME/lib $out
      chmod -R 755 $out/lib
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
<<<<<<< HEAD
    outputHash = "sha256-HfO8yWlL16NuXQ+NWIHwii69Vfb1vvSmNC3+6p0ALdg=";
=======
    outputHash = "sha256-mc/KQrwn3xpPI0ngOLcpoQDaJJm/rM8XgaX//5PiRZk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postUnpack = ''
    export IVY_HOME="$NIX_BUILD_TOP/.ant"
    export ANT_ARGS="-Doffline=true -Ddefault-jar-location=$IVY_HOME/lib"

    # pre-positioning these jar files allows -Doffline=true to work
    mkdir -p source/{bindings,case-uco}/java $IVY_HOME
    cp -r ${finalAttrs.rdeps}/bindings/java/lib source/bindings/java
    chmod -R 755 source/bindings/java
    cp -r ${finalAttrs.rdeps}/case-uco/java/lib source/case-uco/java
    chmod -R 755 source/case-uco/java
    cp -r ${finalAttrs.rdeps}/lib $IVY_HOME
    chmod -R 755 $IVY_HOME
  '';

<<<<<<< HEAD
  patches = [
    # Fix build with gcc 15
    (fetchpatch {
      url = "https://github.com/sleuthkit/sleuthkit/commit/8d710c36a947a2666bbef689155831d76fff56b9.patch";
      hash = "sha256-/mCal0EVTM2dM5ok3OmAXQ1HiaCUi0lmhavIuwxVEMA=";
    })
    (fetchpatch {
      url = "https://github.com/sleuthkit/sleuthkit/commit/f78bd37db6be72f8f4d444d124be4e26488dce4b.patch";
      hash = "sha256-ZEeN0jp5cRi6dOpWlcGYm0nLLu5b56ivdR+WrhnhCz0=";
    })
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  postPatch = ''
    substituteInPlace tsk/img/ewf.cpp --replace libewf_handle_read_random libewf_handle_read_buffer_at_offset
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    ant
    jdk
    perl
    stripJavaArchivesHook
  ];

  buildInputs = [
    afflib
    libewf
    openssl
    zlib
  ];

  # Hack to fix the RPATH
  preFixup = ''
    rm -rf */.libs
  '';

<<<<<<< HEAD
  meta = {
    description = "Forensic/data recovery tool";
    homepage = "https://www.sleuthkit.org/";
    changelog = "https://github.com/sleuthkit/sleuthkit/blob/${finalAttrs.src.rev}/NEWS.txt";
    maintainers = with lib.maintainers; [
      raskin
      gfrascadorio
    ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # dependencies
    ];
    license = lib.licenses.ipl10;
=======
  meta = with lib; {
    description = "Forensic/data recovery tool";
    homepage = "https://www.sleuthkit.org/";
    changelog = "https://github.com/sleuthkit/sleuthkit/blob/${finalAttrs.src.rev}/NEWS.txt";
    maintainers = with maintainers; [
      raskin
      gfrascadorio
    ];
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # dependencies
    ];
    license = licenses.ipl10;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
