{ lib, stdenv
, fetchFromGitHub
, unstableGitUpdater
, SDL
, jack2
, Foundation
}:

stdenv.mkDerivation rec {
  pname = "littlegptracker";
  version = "unstable-2020-11-26";

  src = fetchFromGitHub {
    owner = "Mdashdotdashn";
    repo = "littlegptracker";
    rev = "4aca8cd765e1ad586da62decd019e66cb64b45b8";
    sha256 = "0f2ip8z5wxk8fvlw47mczsbcrzh4nh1hgw1fwf5gjrqnzm8v111x";
  };

  buildInputs = [
    SDL
  ]
  ++ lib.optional stdenv.isDarwin Foundation
  ++ lib.optional stdenv.isLinux jack2;

  patches = [
    # Remove outdated (pre-64bit) checks that would fail on modern platforms
    # (see description in patch file)
    ./0001-Remove-coherency-checks.patch
  ];

  preBuild = "cd projects";

  makeFlags = [ "CXX=${stdenv.cc.targetPrefix}c++" ]
    ++ lib.optionals stdenv.isLinux  [ "PLATFORM=DEB" ]
    ++ lib.optionals stdenv.isDarwin [ "PLATFORM=OSX" ];

  env.NIX_CFLAGS_COMPILE = toString ([ "-fpermissive" ] ++
    lib.optional stdenv.hostPlatform.isAarch64 "-Wno-error=narrowing");

  NIX_LDFLAGS = lib.optional stdenv.isDarwin "-framework Foundation";

  installPhase = let extension = if stdenv.isDarwin then "app" else "deb-exe";
    in "install -Dm555 lgpt.${extension} $out/bin/lgpt";

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/Mdashdotdashn/littlegptracker.git";
  };

  meta = with lib; {
    description = "A music tracker similar to lsdj optimised to run on portable game consoles";
    longDescription = ''
      LittleGPTracker (a.k.a 'The piggy', 'lgpt') is a music tracker optimised
      to run on portable game consoles. It is currently running on Game Park's
      GP2x & Caanoo, PSP, Dingoo, Windows, Mac OSX (intel/ppc) & Linux (Debian).

      It implements the user interface of littlesounddj, a very famous tracker
      for the Gameboy platform that has been tried and tested by many users over
      the years, leading to a little complex but yet extremely efficent way of
      working.

      Piggy currently supports 8 monophonic 16Bit/44.1Khz stereo sample playback
      channels. Additionally, the program can drive MIDI instruments (with the
      gp32 and gp2x a custom MIDI interface is required).
    '';
    homepage = "https://www.littlegptracker.com/";
    downloadPage = "https://www.littlegptracker.com/download.php";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    # https://github.com/NixOS/nixpkgs/pull/91766#issuecomment-688751821
    broken = stdenv.isDarwin;
  };
}
