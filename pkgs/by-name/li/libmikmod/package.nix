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
stdenv.mkDerivation rec {
  pname = "libmikmod";
  version = "3.3.13";

  src = fetchurl {
    url = "mirror://sourceforge/mikmod/libmikmod-${version}.tar.gz";
    sha256 = "sha256-n8F5n36mqVx8WILemL6F/H0gugpKb8rK4RyMazgrsgc=";
  };

  buildInputs = [ texinfo ] ++ optional stdenv.hostPlatform.isLinux alsa-lib;
  propagatedBuildInputs = optional stdenv.hostPlatform.isLinux libpulseaudio;

  outputs = [
    "out"
    "dev"
    "man"
  ];

  NIX_LDFLAGS = optionalString stdenv.hostPlatform.isLinux "-lasound";

  enableParallelBuilding = true;

  postInstall = ''
    moveToOutput bin/libmikmod-config "$dev"
  '';

  meta = with lib; {
    description = "Library for playing tracker music module files";
    mainProgram = "libmikmod-config";
    homepage = "https://mikmod.shlomifish.org/";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [
      lovek323
    ];
    platforms = platforms.unix;

    longDescription = ''
      A library for playing tracker music module files supporting many formats,
      including MOD, S3M, IT and XM.
    '';
  };
}
