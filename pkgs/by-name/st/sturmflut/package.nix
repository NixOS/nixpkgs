{
  stdenv,
  lib,
  pkg-config,
  imagemagick,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "sturmflut";
  version = "0-unstable-2023-04-25";

  src = fetchFromGitHub {
    owner = "TobleMiner";
    repo = "sturmflut";
    rev = "0e3092ab6db23d2529b8ddc95e5d5e2c3ae8fc9d";
    hash = "sha256-amNkCDdfG1AqfQ5RCT4941uOtjQRSFt/opzE8yIaftc=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ imagemagick ];

  installPhase = ''
    runHook preInstall
    install -m755 -D sturmflut $out/bin/sturmflut
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Fast (80+ Gbit/s) pixelflut client with full IPv6 and animation support";
    homepage = "https://github.com/TobleMiner/sturmflut";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zebreus ];
    platforms = lib.platforms.linux;
    mainProgram = "sturmflut";
  };
}
