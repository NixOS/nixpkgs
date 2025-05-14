{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  perl,
  python3,
  tbb,
  zlib,
  runCommand,
  bowtie2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bowtie2";
  version = "2.5.4";

  src = fetchFromGitHub {
    owner = "BenLangmead";
    repo = "bowtie2";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-ZbmVOItfAgKdsMrvQIXgKiPtoQJZYfGblCGDoNPjvTU=";
  };

  # because of this flag, gcc on aarch64 cannot find the Threads
  # Could NOT find Threads (missing: Threads_FOUND)
  # TODO: check with other distros and report upstream
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "-m64" ""
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    tbb
    zlib
    python3
    perl
  ];

  cmakeFlags = lib.optional (!stdenv.hostPlatform.isx86) [
    "-DCMAKE_CXX_FLAGS=-I${finalAttrs.src}/third_party"
  ];

  # ctest fails because of missing dependencies between tests
  doCheck = false;

  passthru.tests = {
    ctest = runCommand "${finalAttrs.pname}-test" { } ''
      mkdir $out
      ${lib.getExe bowtie2} -x ${finalAttrs.src}/example/index/lambda_virus ${finalAttrs.src}/example/reads/longreads.fq -u 10
      ${bowtie2}/bin/bowtie2-build-s -c GGGCGGCGACCTCGCGGGTTTTCGCTA $out/small
      ${bowtie2}/bin/bowtie2-inspect-s $out/small
      ${bowtie2}/bin/bowtie2-build-l -c GGGCGGCGACCTCGCGGGTTTTCGCTA $out/large
      ${bowtie2}/bin/bowtie2-inspect-l $out/large
    '';
  };

  meta = with lib; {
    description = "Ultrafast and memory-efficient tool for aligning sequencing reads to long reference sequences";
    license = licenses.gpl3Plus;
    homepage = "http://bowtie-bio.sf.net/bowtie2";
    changelog = "https://github.com/BenLangmead/bowtie2/releases/tag/v${finalAttrs.version}";
    maintainers = with maintainers; [ rybern ];
    platforms = platforms.all;
    mainProgram = "bowtie2";
  };
})
