{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  curl,
  jansson,
  perl,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "cpuminer";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "pooler";
    repo = pname;
    rev = "v${version}";
    sha256 = "0f44i0z8rid20c2hiyp92xq0q0mjj537r05sa6vdbc0nl0a5q40i";
  };

  patches = [
    (fetchpatch {
      name = "fix-build-on-aarch64.patch";
      url = "https://github.com/pooler/cpuminer/commit/5f02105940edb61144c09a7eb960bba04a10d5b7.patch";
      hash = "sha256-lGAcwDcXgcJBFhasSEdQIEIY7pp6x/PEXHBsVwAOqhc=";
    })
  ];

  postPatch = if stdenv.cc.isClang then "${perl}/bin/perl ./nomacro.pl" else null;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    curl
    jansson
  ];

  configureFlags = [ "CFLAGS=-O3" ];

  meta = with lib; {
    homepage = "https://github.com/pooler/cpuminer";
    description = "CPU miner for Litecoin and Bitcoin";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
    mainProgram = "minerd";
  };
}
