{ fetchFromGitHub
, lib
, cmake
, mkDerivation
, libxcb
, qtbase
, qtsvg
}:

mkDerivation rec {
   pname = "spotify-qt";
   version = "3.9";

   src = fetchFromGitHub {
      owner = "kraxarn";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-8rLpasgXiaL2KpGnYMQdNN2ayjcSkmz5hDkNBnKNWHk=";
   };

   buildInputs = [ libxcb qtbase qtsvg ];

   nativeBuildInputs = [ cmake ];

   cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" "-DCMAKE_INSTALL_PREFIX=" ];

   installFlags = [ "DESTDIR=$(out)" ];

   meta = with lib; {
    description = "Lightweight unofficial Spotify client using Qt";
    homepage = "https://github.com/kraxarn/spotify-qt";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
   };
}
