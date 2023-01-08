{ lib
, gawk
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "lukesmithxyz-bible-vul";
  version = "unstable-2022-06-01";

  src = fetchFromGitHub {
    owner = "lukesmithxyz";
    repo = "vul";
    rev = "97efaedb79c9de62b6a19b04649fd8c00b85973f";
    hash = "sha256-NwRUx7WVvexrCdPtckq4Szf5ISy7NVBHX8uAsRtbE+0=";
  };

  buildInputs = [ gawk ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Read the Word of God in Latin Vulgate from your terminal.";
    homepage = "https://lukesmith.xyz/articles/command-line-bibles";
    license = licenses.unlicense;
    platforms = platforms.unix;
    maintainers = [ maintainers.wesleyjrz ];
  };
}
