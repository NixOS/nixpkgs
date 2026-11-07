{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  soapysdr,
  avahi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapyremote";
  version = "0.5.2-unstable-2024-01-24";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyRemote";
    rev = "54caa5b2af348906607c5516a112057650d0873d";
    hash = "sha256-uekElbcbX2P5TEufWEoP6tgUM/4vxgSQZu8qaBCSo18=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/pothosware/SoapyRemote/commit/40c3ef9053b63885b7444ce7e9ef00d2c7964c9d.patch";
      hash = "sha256-kEx4gge+AQW/LSUyo+aWXlqDzXjoxCfn3pi2mk5xsNI=";
    })
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    soapysdr
    avahi
  ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [ "-include sys/select.h" ]
  );

  meta = {
    homepage = "https://github.com/pothosware/SoapyRemote";
    description = "SoapySDR plugin for remote access to SDRs";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.unix;
    mainProgram = "SoapySDRServer";
  };
})
