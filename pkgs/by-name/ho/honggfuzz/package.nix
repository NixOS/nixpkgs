{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  clang,
  llvm,
  libbfd,
  libopcodes,
  libunwind,
  libblocksruntime,
}:

stdenv.mkDerivation rec {
  pname = "honggfuzz";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "google";
    repo = "honggfuzz";
    rev = version;
    sha256 = "sha256-/ra6g0qjjC8Lo8/n2XEbwnZ95yDHcGhYd5+TTvQ6FAc=";
  };

  postPatch = ''
    substituteInPlace hfuzz_cc/hfuzz-cc.c \
      --replace '"clang' '"${clang}/bin/clang'
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ llvm ];
  propagatedBuildInputs = [
    libbfd
    libopcodes
    libunwind
    libblocksruntime
  ];

  # Fortify causes build failures: 'str*' defined both normally and as 'alias' attribute
  hardeningDisable = [ "fortify" ];

  makeFlags = [
    "PREFIX=$(out)"
    # hfuzz-cc can only find 'includes' folder (instead of 'include')
    # Defined here: https://github.com/google/honggfuzz/blob/defed1013fdacd7090617ecc1ced8bdcc3c617d6/hfuzz_cc/hfuzz-cc.c#L273
    "INC_PATH=$(PREFIX)/includes"
    "HFUZZ_INC=$(out)"
  ];

  postInstall = ''
    mkdir -p $out/lib
    cp libhfuzz/libhfuzz.a $out/lib
    cp libhfuzz/libhfuzz.so $out/lib
    cp libhfcommon/libhfcommon.a $out/lib
    cp libhfnetdriver/libhfnetdriver.a $out/lib
  '';

  meta = {
    description = "Security oriented, feedback-driven, evolutionary, easy-to-use fuzzer";
    longDescription = ''
      Honggfuzz is a security oriented, feedback-driven, evolutionary,
      easy-to-use fuzzer with interesting analysis options. It is
      multi-process and multi-threaded, blazingly fast when the persistent
      fuzzing mode is used and has a solid track record of uncovered security
      bugs.

      Honggfuzz uses low-level interfaces to monitor processes and it will
      discover and report hijacked/ignored signals from crashes. Feed it
      a simple corpus directory (can even be empty for the feedback-driven
      fuzzing), and it will work its way up, expanding it by utilizing
      feedback-based coverage metrics.
    '';
    homepage = "https://honggfuzz.dev/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      cpu
      chivay
    ];
  };
}
