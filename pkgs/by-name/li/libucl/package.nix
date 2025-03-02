{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  curl,
  lua,
  openssl,
  features ? {
    urls = false;
    # Upstream enables regex by default
    regex = true;
    # Signature support is broken with openssl 1.1.1: https://github.com/vstakhov/libucl/issues/203
    signatures = false;
    lua = false;
    utils = false;
  },
}:

let
  featureDeps = {
    urls = [ curl ];
    signatures = [ openssl ];
    lua = [ lua ];
  };
in
stdenv.mkDerivation rec {
  pname = "libucl";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = pname;
    rev = version;
    sha256 = "sha256-esNEVBa660rl3Oo2SLaLrFThFkjbqtZ1r0tjMq3h6cM=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = lib.concatLists (
    lib.mapAttrsToList (feat: enabled: lib.optionals enabled (featureDeps."${feat}" or [ ])) features
  );

  enableParallelBuilding = true;

  configureFlags = lib.mapAttrsToList (
    feat: enabled: lib.strings.enableFeature enabled feat
  ) features;

  meta = with lib; {
    description = "Universal configuration library parser";
    homepage = "https://github.com/vstakhov/libucl";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jpotier ];
  };
}
