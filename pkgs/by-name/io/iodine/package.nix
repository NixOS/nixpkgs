{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  net-tools,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iodine";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "yarrick";
    repo = "iodine";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0vDl/F/57puugrEdOtdlpNPMF9ugO7TP3KLWo/7bP2k=";
  };

  buildInputs = [ zlib ];

  env.NIX_CFLAGS_COMPILE = ''-DIFCONFIGPATH="${net-tools}/bin/" -DROUTEPATH="${net-tools}/bin/"'';

  installFlags = [ "prefix=\${out}" ];

  passthru.tests = {
    inherit (nixosTests) iodine;
  };

  meta = {
    homepage = "https://code.kryo.se/iodine/";
    description = "Tool to tunnel IPv4 data through a DNS server";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
