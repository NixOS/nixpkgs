{
  lib,
  stdenv,
  fetchurl,
  buildInputs,
  hash,
  version,
  url,
  knownVulnerabilities,
}:

stdenv.mkDerivation rec {
  pname = "libdwarf";
  inherit version;

  src = fetchurl {
    inherit url hash;
  };

  configureFlags = [
    "--enable-shared"
    "--disable-nonshared"
  ];

  inherit buildInputs;

  outputs = [
    "bin"
    "lib"
    "dev"
    "out"
  ];

  meta = {
    homepage = "https://github.com/davea42/libdwarf-code";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.atry ];
    inherit knownVulnerabilities;
  };
}
