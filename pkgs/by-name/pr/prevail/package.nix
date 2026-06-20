{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  catch2_3,
  microsoft-gsl,
  pkg-config,
  replaceVars,
  yaml-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prevail";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "vbpf";
    repo = "prevail";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-qlQSoz9GE2Z2rzmrPIj+HnIQmNxiBSgvR40FR9psuDc=";
  };

  patches = [
    (replaceVars ./remove-fetchcontent-usage.patch {
      # We will download them instead of cmake's fetchContent
      catch2Src = catch2_3.src;
      gslSrc = microsoft-gsl.src;
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    boost
    yaml-cpp
  ];

  cmakeFlags = [
    (lib.cmakeBool "prevail_ENABLE_TESTS" finalAttrs.doCheck)
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ../bin/prevail $out/bin/prevail

    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    pushd ..
    bin/tests
    popd
    runHook postCheck
  '';

  meta = {
    description = "eBPF verifier based on abstract interpretation";
    homepage = "https://github.com/vbpf/prevail";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "prevail";
  };
})
