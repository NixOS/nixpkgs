{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  cmake,
  hdf5,
  versionCheckHook,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "kallisto";
  version = "0.51.1";

  src = fetchFromGitHub {
    repo = "kallisto";
    owner = "pachterlab";
    rev = "v${version}";
    sha256 = "sha256-hfdeztEyHvuOnLS71oSv8sPqFe2UCX5KlANqrT/Gfx8=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt ext/bifrost/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.0.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    autoconf
    cmake
  ];

  buildInputs = [
    hdf5
    zlib
  ];

  cmakeFlags = [ "-DUSE_HDF5=ON" ];

  enableParallelBuilding = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Near-optimal quantification of transcripts from RNA-seq data";
    longDescription = ''
      kallisto is a program for quantifying abundances of transcripts
      from RNA sequencing data, or more generally of target sequences
      using high-throughput sequencing reads. It is based on the novel
      idea of pseudoalignment for rapidly determining the
      compatibility of reads with targets, without the need for
      alignment.
    '';
    mainProgram = "kallisto";
    homepage = "https://pachterlab.github.io/kallisto";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.arcadio ];
  };
}
