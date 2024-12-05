{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  xxd,
  perl,
  installShellFiles,
  enableAvx2 ? stdenv.hostPlatform.avx2Support,
  enableSse4_1 ? stdenv.hostPlatform.sse4_1Support,
  enableMpi ? false,
  mpi,
  openmp,
  zlib,
  bzip2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mmseqs2";
  version = "16-747c6";

  src = fetchFromGitHub {
    owner = "soedinglab";
    repo = "mmseqs2";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-O7tx+gdVAmZLihPnWSo9RWNVzfPjI61LGY/XeaGHrI0=";
  };

  nativeBuildInputs = [
    cmake
    xxd
    perl
    installShellFiles
  ];

  cmakeFlags = [
    (lib.cmakeBool "HAVE_AVX2" enableAvx2)
    (lib.cmakeBool "HAVE_SSE4_1" enableSse4_1)
    (lib.cmakeBool "HAVE_MPI" enableMpi)
  ];

  buildInputs =
    lib.optionals stdenv.cc.isClang [
      openmp
      zlib
      bzip2
    ]
    ++ lib.optional enableMpi mpi;

  postInstall = ''
    installShellCompletion --bash --cmd mmseqs $out/util/bash-completion.sh
    rm -r $out/util/
  '';

  meta = with lib; {
    description = "Ultra fast and sensitive sequence search and clustering suite";
    mainProgram = "mmseqs";
    homepage = "https://mmseqs.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
