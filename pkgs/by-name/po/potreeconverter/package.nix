{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  onetbb,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "PotreeConverter";
  version = "unstable-2023-02-27";

  src = fetchFromGitHub {
    owner = "potree";
    repo = "PotreeConverter";
    rev = "af4666fa1090983d8ce7c11dcf49ba19eda90995";
    sha256 = "sha256-QYNY+/v6mBEJFiv3i2QS+zqkgWJqeqXSqNoh+ChAiQA=";
  };

  buildInputs = [
    boost
    onetbb
  ];

  nativeBuildInputs = [
    makeWrapper
    cmake
  ];

  cmakeFlags = [ (lib.strings.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5") ];

  postPatch = ''
    runHook prePatch

    substituteInPlace ./CMakeLists.txt \
      --replace "find_package(TBB REQUIRED)" ""

    # prevent inheriting permissions from /nix/store when copying
    substituteInPlace Converter/src/main.cpp --replace \
      'fs::copy(templateDir, pagedir, fs::copy_options::overwrite_existing | fs::copy_options::recursive)' 'string cmd = "cp --no-preserve=mode -r " + templateDir + " " + pagedir; system(cmd.c_str());'
  '';

  # The upstream build system does not provide an install target.
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

  postFixup = ''
    ln -s $src/resources $out/bin/resources
  '';

  meta = with lib; {
    description = "Create multi res point cloud to use with potree";
    homepage = "https://github.com/potree/PotreeConverter";
    license = licenses.bsd2;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = with platforms; linux;
  };
}
