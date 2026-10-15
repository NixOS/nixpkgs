{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  avahi-compat,
  libao,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shairplay-unstable";
  version = "2018-08-24";

  src = fetchFromGitHub {
    owner = "juhovh";
    repo = "shairplay";
    rev = "096b61ad14c90169f438e690d096e3fcf87e504e";
    hash = "sha256-SvMUW/oaMcR1n+fhiXd5cpC9U+Llf5gRxOumQ1Vqsws=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    avahi-compat
    libao
  ];

  enableParallelBuilding = true;

  # the build will fail without complaining about a reference to /tmp
  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf \
      --set-rpath "${lib.makeLibraryPath finalAttrs.buildInputs}:$out/lib" \
      $out/bin/shairplay
  '';

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Apple AirPlay and RAOP protocol server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.unix;
    mainProgram = "shairplay";
  };
})
