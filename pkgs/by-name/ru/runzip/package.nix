{
  lib,
  stdenv,
  fetchFromGitHub,
  libiconv,
  zlib,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.4";
  pname = "runzip";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    libiconv
    zlib
  ];

  src = fetchFromGitHub {
    owner = "vlm";
    repo = "zip-fix-filename-encoding";
    rev = "v${finalAttrs.version}";
    sha256 = "0l5zbb5hswxczigvyal877j0aiq3fc01j3gv88bvy7ikyvw3lc07";
  };

  postPatch = ''
    patchShebangs tests/check-runzip.sh
  '';

  configureFlags = [ "CFLAGS=-std=gnu17" ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=implicit-int"
    "-Wno-error=incompatible-pointer-types"
  ];

  doCheck = true;

  meta = {
    description = "Tool to convert filename encoding inside a ZIP archive";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.raskin ];
    # runzip vendors libzip 0.7.1.
    knownVulnerabilities = [
      "CVE-2015-2331"
      "CVE-2017-14107"
    ];
    platforms = lib.platforms.unix;
    mainProgram = "runzip";
  };
})
