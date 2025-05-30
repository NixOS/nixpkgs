{
  lib,
  llvmPackages,
  fetchFromGitHub,
  opencflite,
  libuuid,
  zlib,
}:

let
  stdenv = llvmPackages.libcxxStdenv;
in
stdenv.mkDerivation {
  pname = "maloader";
  version = "0-unstable-2018-05-02";

  src = fetchFromGitHub {
    owner = "shinh";
    repo = "maloader";
    rev = "464a90fdfd06a54c9da5d1a3725ed6229c0d3d60";
    hash = "sha256-0N3+tr8XUsn3WhJNsPVknumBrfMgDawTEXVRkIs/IV8=";
  };

  postPatch = ''
    substituteInPlace ld-mac.cc \
      --replace-fail 'loadLibMac(mypath)' 'loadLibMac("${placeholder "out"}/lib/")' \
      --replace-fail 'libCoreFoundation.so' '${opencflite}/lib/libCoreFoundation.so'
    substituteInPlace libmac/stack_protector-obsd.c \
      --replace-fail 'sys/sysctl.h' 'linux/sysctl.h'
  '';

  buildInputs = [
    libuuid
    zlib
  ];

  buildFlags = [
    "USE_LIBCXX=1"
    "release"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-command-line-argument";

  installPhase = ''
    runHook preInstall

    install -vD libmac.so "$out/lib/libmac.so"

    for bin in extract macho2elf ld-mac; do
      install -vD "$bin" "$out/bin/$bin"
    done

    runHook postInstall
  '';

  meta = {
    description = "Mach-O loader for Linux";
    homepage = "https://github.com/shinh/maloader";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ wegank ];
    inherit (opencflite.meta) platforms;
  };
}
