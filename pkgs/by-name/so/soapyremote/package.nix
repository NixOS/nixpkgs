{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  soapysdr,
  avahi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapyremote";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyRemote";
    tag = "soapy-remote-${finalAttrs.version}";
    hash = "sha256-+/EhkPJa6IctQ1T82AO0l1Y47YOMRjAoL/QEXnVHOd4=";
  };

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
