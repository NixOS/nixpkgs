{
  lib,
  stdenv,
  fetchurl,
  texinfo,
  alsa-lib,
  libpulseaudio,
}:

let
  inherit (lib) optional optionalString;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "libmikmod";
  version = "3.3.16";

  src = fetchurl {
    url = "mirror://sourceforge/mikmod/libmikmod-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-eyTkFGiw3+f64RBK5qDXxS4Epl4YUbJoxwdOTQZoWlM=";
  };

  buildInputs = [ texinfo ] ++ optional stdenv.hostPlatform.isLinux alsa-lib;
  propagatedBuildInputs = optional stdenv.hostPlatform.isLinux libpulseaudio;

  outputs = [
    "out"
    "dev"
    "man"
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    NIX_LDFLAGS = "-lasound";
  };

  enableParallelBuilding = true;

  postInstall = ''
    moveToOutput bin/libmikmod-config "$dev"
  '';

  meta = {
    description = "Library for playing tracker music module files";
    mainProgram = "libmikmod-config";
    homepage = "https://mikmod.shlomifish.org/";
    license = lib.licenses.lgpl2Plus;
    maintainers = [
    ];
    platforms = lib.platforms.unix;

    longDescription = ''
      A library for playing tracker music module files supporting many formats,
      including MOD, S3M, IT and XM.
    '';
  };
})
