{ lib, stdenv, fetchurl, xorgproto, libXt, libX11
, gifview ? false
, static ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "gifsicle";
  version = "1.95";

  src = fetchurl {
    url = "https://www.lcdf.org/gifsicle/gifsicle-${version}.tar.gz";
    hash = "sha256-snEWRwCf0qExMPO+FgUy7UZTjnYr/A8CDepQYYp9yVA=";
  };

  buildInputs = lib.optionals gifview [ xorgproto libXt libX11 ];

  configureFlags = lib.optional (!gifview) "--disable-gifview";

  LDFLAGS = lib.optionalString static "-static";

  doCheck = true;
  checkPhase = ''
    ./src/gifsicle --info logo.gif
  '';

  meta = {
    description = "Command-line tool for creating, editing, and getting information about GIF images and animations";
    homepage = "https://www.lcdf.org/gifsicle/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}
