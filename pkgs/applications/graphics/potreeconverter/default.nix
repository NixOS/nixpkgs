{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, tbb
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "PotreeConverter";
  version = "unstable-2022-08-04";

  src = fetchFromGitHub {
    owner = "potree";
    repo = "PotreeConverter";
    rev = "758bbac98a662de5e57d2280675e11cc76241688";
    sha256 = "sha256-pDdV2/edYhhBWs153hSy1evI3cXD0Xq9nrEsw3JNcH4=";
  };

  buildInputs = [
    boost
    tbb
  ];

  nativeBuildInputs = [
    makeWrapper
    cmake
  ];

  patchPhase = ''
    runHook prePatch

    substituteInPlace ./CMakeLists.txt \
      --replace "find_package(TBB REQUIRED)" ""

    # prevent inheriting permissions from /nix/store when copying
    substituteInPlace Converter/src/main.cpp --replace \
      'fs::copy(templateDir, pagedir, fs::copy_options::overwrite_existing | fs::copy_options::recursive)' 'string cmd = "cp --no-preserve=mode -r " + templateDir + " " + pagedir; system(cmd.c_str());'

    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib}
    mv liblaszip.so $out/lib
    mv PotreeConverter $out/bin
    ln -s $out/bin/PotreeConverter $out/bin/potreeconverter

    # Create an empty wrapper, since PotreeConverter segfaults if called via
    # $PATH rather than absolute path. An empty wrapper forces an absolute path
    # on each invocation
    wrapProgram $out/bin/PotreeConverter

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup
    ln -s $src/resources $out/bin/resources
    runHook postFixup
  '';

  meta = with lib; {
    description = "Create multi res point cloud to use with potree";
    homepage = "https://github.com/potree/PotreeConverter";
    license = licenses.bsd2;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = with platforms; linux;
  };
}
