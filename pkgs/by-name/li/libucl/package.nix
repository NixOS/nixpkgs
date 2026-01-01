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
<<<<<<< HEAD
  version = "0.9.3";
=======
  version = "0.9.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = "libucl";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-dub829xZ10sJ5qwegYUiGoyAVLiwg44GKSzz+BMLJis=";
=======
    sha256 = "sha256-esNEVBa660rl3Oo2SLaLrFThFkjbqtZ1r0tjMq3h6cM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Universal configuration library parser";
    homepage = "https://github.com/vstakhov/libucl";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jpotier ];
=======
  meta = with lib; {
    description = "Universal configuration library parser";
    homepage = "https://github.com/vstakhov/libucl";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jpotier ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
