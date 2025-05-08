{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fftwFloat,
  libsamplerate,
}:

stdenv.mkDerivation rec {
  pname = "csdr";
  version = "0.18.29";

  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "csdr";
    rev = "a10bd230fc42f71a0736a82b5e7997674923a5ea";
    hash = "sha256-eutqE8tc6/6oLDGZ+AVw0A1Sy3zg+ModtP9e9H4anFM=";
  };

  postPatch = ''
    # function is not defined in any headers but used in libcsdr.c
    echo "int errhead();" >> src/predefined.h
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

  meta = with lib; {
    homepage = "https://github.com/luarvique/csdr";
    description = "Simple DSP library and command-line tool for Software Defined Radio";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    teams = [ teams.c3d2 ];
  };
}
