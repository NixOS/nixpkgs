{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fftwFloat,
  libsamplerate,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "csdr";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "jketterl";
    repo = "csdr";
    rev = version;
    sha256 = "sha256-LdVzeTTIvDQIXRdcz/vpQu/fUgtE8nx1kIEfoiwxrUg=";
  };

  postPatch = ''
    # function is not defined in any headers but used in libcsdr.c
    echo "int errhead();" >> src/predefined.h

    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required (VERSION 3.0)" \
      "cmake_minimum_required (VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  propagatedBuildInputs = [
    fftwFloat
    libsamplerate
  ];

  hardeningDisable = lib.optional stdenv.hostPlatform.isAarch64 "format";

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/csdr.pc \
      --replace '=''${prefix}//' '=/' \
      --replace '=''${exec_prefix}//' '=/'
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = with lib; {
    homepage = "https://github.com/jketterl/csdr";
    description = "Simple DSP library and command-line tool for Software Defined Radio";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
