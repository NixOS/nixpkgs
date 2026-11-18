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
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyRemote";
    tag = "soapy-remote-${finalAttrs.version}";
    hash = "sha256-ZXNxXqQeVkq2UMyk5Icy4K1LXxNvr7q+21203Q5K7sA=";
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
