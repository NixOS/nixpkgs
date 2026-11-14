{
  lib,
  autoreconfHook,
  stdenv,
  libtool,
  fetchFromGitHub,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scamper";
  version = "20260713";

  src = fetchFromGitHub {
    owner = "alistairking";
    repo = "scamper";
    rev = "0f77b971cb10b7ca821e7090ff5da1c0f1ff8393";
    hash = "sha256-sFYYr9SUW+mRMyg9V4McCVZCWZP3xXknLcazW9ERvpI=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoreconfHook
    libtool
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "scamper -v";
  };

  meta = {
    description = "Like its predecessor skitter, scamper is a feature-rich tool that actively probes the Internet in order to analyze topology and performance.";
    homepage = "https://www.caida.org/catalog/software/scamper/";
    license = lib.licenses.gpl2;
    mainProgram = "scamper";
    maintainers = with lib.maintainers; [ robertrichter ];
    platforms = libtool.meta.platforms;
  };
})
