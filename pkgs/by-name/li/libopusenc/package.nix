{
  lib,
  stdenv,
  pkg-config,
  libopus,
  testers,
  autoreconfHook,
  fetchFromGitLab,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libopusenc";
  version = "0.3";

  src = fetchFromGitLab {
    domain = "gitlab.xiph.org";
    owner = "xiph";
    repo = "libopusenc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-n4wmIUyCNPpgHhyRpv4Xpw292M6XRFhQtuY77x6+7JA=";
  };

  postPatch = ''
    echo PACKAGE_VERSION="${finalAttrs.version}" > ./package_version
  '';

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  doCheck = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [ libopus ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Library for encoding .opus audio files and live streams";
    license = lib.licenses.bsd3;
    homepage = "https://www.opus-codec.org/";
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "libopusenc" ];
    maintainers = with lib.maintainers; [ pmiddend ];
  };
})
