{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  freetype,
  pango,
  SDL2,
  darwin,
}:

stdenv.mkDerivation rec {
  pname = "sdl2-pango";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "markuskimius";
    repo = "SDL2_Pango";
    rev = "v${version}";
    hash = "sha256-8SL5ylxi87TuKreC8m2kxlLr8rcmwYYvwkp4vQZ9dkc=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    SDL2
  ];

  buildInputs =
    [
      freetype
      pango
      SDL2
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.libobjc
    ];

  meta = with lib; {
    description = "A library for graphically rendering internationalized and tagged text in SDL2 using TrueType fonts";
    homepage = "https://github.com/markuskimius/SDL2_Pango";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ rardiol ];
    platforms = platforms.all;
  };
}
