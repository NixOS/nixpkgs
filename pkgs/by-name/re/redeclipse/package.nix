{ lib, stdenv, fetchurl
, curl, ed, pkg-config, freetype, zlib, libX11
, SDL2, SDL2_image, SDL2_mixer
}:

stdenv.mkDerivation rec {
  pname = "redeclipse";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/redeclipse/base/releases/download/v${version}/redeclipse_${version}_nix.tar.bz2";
    sha256 = "143i713ggbk607qr4n39pi0pn8d93x9x6fcbh8rc51jb9qhi8p5i";
  };

  buildInputs = [
    libX11 freetype zlib
    SDL2 SDL2_image SDL2_mixer
  ];

  nativeBuildInputs = [
    curl ed pkg-config
  ];

  makeFlags = [ "-C" "src/" "prefix=$(out)" ];

  enableParallelBuilding = true;

  installTargets = [ "system-install" ];

  postInstall = ''
      cp -R -t $out/share/redeclipse/data/ data/*
  '';

  meta = with lib; {
    description = "First person arena shooter, featuring parkour, impulse boosts, and more";
    longDescription = ''
      Red Eclipse is a fun-filled new take on the first person arena shooter,
      featuring parkour, impulse boosts, and more. The development is geared
      toward balanced gameplay, with a general theme of agility in a variety of
      environments.
    '';
    homepage = "https://www.redeclipse.net";
    license = with licenses; [ licenses.zlib cc-by-sa-30 ];
    maintainers = with maintainers; [ lambda-11235 ];
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
