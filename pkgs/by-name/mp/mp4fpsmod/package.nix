{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, ...
} @ args:

stdenv.mkDerivation rec {
  pname = "mp4fpsmod";
  version = "0.27";

  src = fetchFromGitHub ({
    owner = "nu774";
    repo = "mp4fpsmod";
    rev = "v${version}";
    sha256 = "sha256-87gcike8zIRkkXRBC5bUIZtgsbVyghPqV3Ni87EaK2s";
  });

  nativeBuildInputs = [
    autoreconfHook
  ];

  enableParallelBuilding = true;

  preConfigure = ''
  ./bootstrap.sh
  '';

  patches = [ ./c++11.patch ];

  meta = with lib; {
    description = "Tiny mp4 time code editor";
    longDescription = "Tiny mp4 time code editor. You can use this for changing fps, delaying audio tracks, executing DTS compression, extracting time codes of mp4.";
    homepage = "https://github.com/nu774/mp4fpsmod";
    license = with lib.licenses; [
      # All files are distributed as Public Domain, except for the followings:
      "MPL-1.1" #mp4v2
      "BSL-1.0" #Boost
      "BSD-2-Clause" #FreeBSD CVS
    ];
    platforms = platforms.all;
    maintainers = with lib.maintainers; [ huggy ];
  };
}