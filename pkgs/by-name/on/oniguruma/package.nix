{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oniguruma";
  version = "6.9.10";

  # Note: do not use fetchpatch or fetchFromGitHub to keep this package available in __bootPackages
  src = fetchurl {
    url = "https://github.com/kkos/oniguruma/releases/download/v${finalAttrs.version}/onig-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-Klz8WuJZ5Ol/hraN//wVLNr/6U4gYLdwy4JyONdp/AU=";
  };

  outputs = [
    "dev"
    "lib"
    "out"
  ];
  outputBin = "dev"; # onig-config

  nativeBuildInputs = [ autoreconfHook ];
  configureFlags = [ "--enable-posix-api=yes" ];

  passthru.bin = finalAttrs.finalPackage.${finalAttrs.outputBin}; # fix lib.getExe

  meta = with lib; {
    homepage = "https://github.com/kkos/oniguruma";
    description = "Regular expressions library";
    mainProgram = "onig-config";
    license = licenses.bsd2;
    maintainers = with maintainers; [ artturin ];
    platforms = platforms.unix;
  };
})
