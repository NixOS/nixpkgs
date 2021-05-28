{ stdenv
, fetchFromGitHub
, SDL
, jack2
, Foundation
}:

stdenv.mkDerivation rec {
  pname = "littlegptracker";
  version = "unstable-2019-04-14";

  src = fetchFromGitHub {
    owner = "Mdashdotdashn";
    repo = "littlegptracker";
    rev = "0ed729b46739e3df5e111c6fa4d548fde2d3b891";
    sha256 = "1pc6lg2qp6xh7ahs5d5pb63ms4h2dz7ryp3c7mci4g37gbwbsj5b";
  };

  buildInputs = [
    SDL
  ]
  ++ stdenv.lib.optional stdenv.isDarwin Foundation
  ++ stdenv.lib.optional stdenv.isLinux jack2;

  patches = [
    # Remove outdated (pre-64bit) checks that would fail on modern platforms
    # (see description in patch file)
    ./0001-Remove-coherency-checks.patch
    # Set starting directory to cwd, default is in /nix/store and causes a crash
    # (see description in patch file)
    ./0002-Set-the-initial-directory-to-the-current-directory.patch
  ];

  preBuild = "cd projects";

  makeFlags = [ "CXX=${stdenv.cc.targetPrefix}c++" ]
    ++ stdenv.lib.optionals stdenv.isLinux  [ "PLATFORM=DEB" ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ "PLATFORM=OSX" ];

  NIX_CFLAGS_COMPILE = [ "-fpermissive" ] ++
    stdenv.lib.optional stdenv.hostPlatform.isAarch64 "-Wno-error=narrowing";

  NIX_LDFLAGS = stdenv.lib.optional stdenv.isDarwin "-framework Foundation";

  installPhase = let extension = if stdenv.isDarwin then "app" else "deb-exe";
    in "install -Dm555 lgpt.${extension} $out/bin/lgpt";

  meta = with stdenv.lib; {
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
    homepage = "http://www.littlegptracker.com/";
    downloadPage = "http://www.littlegptracker.com/download.php";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    # https://github.com/NixOS/nixpkgs/pull/91766#issuecomment-688751821
    broken = stdenv.isDarwin;
  };
}
