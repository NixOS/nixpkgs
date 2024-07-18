{ lib
, stdenv
, fetchgit
, zig
, SDL2
, SDL2_ttf
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "popping-dikr";
  version = "1.1.2";

  src = fetchgit {
    url = "https://github.com/muslimDevCommunity/PoppingDikr.git";
    rev = "78239ee4aef80ab3d4aa0cea0602ee5a7b78136c";
    hash = "sha256-6uxvMTmRcGncVletEX2+GiIrZCX1gnG9lEp3ciwfL+A=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    SDL2.dev
    SDL2_ttf
    zig.hook
  ];

  meta = with lib; {
    description = "Dikr app that shows itself every now and then";
    homepage = "https://github.com/muslimDevCommunity/PoppingDikr";
    license = licenses.mit;
    mainProgram = "popping-dikr";
    inherit (zig.meta) platforms;
    maintainers = with maintainers; [ IbrahimOuhamou ];
  };
}
