{ stdenv
, fetchFromGitHub
, meson
, pkgconfig
, ninja
, ffmpeg
, SDL2
, android-studio
, jdk8
, gradle
}:

stdenv.mkDerivation rec {
  name = "srcpy";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "Genymobile";
    repo = name;
    rev = "v${version}";
    sha256 = "16zi0d2jjm2nlrwkwvsxzfpgy45ami45wfh67wq7na2h2ywfmgcp";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    android-studio
    jdk8
    gradle
  ];

  buildInputs = [
    ffmpeg
    SDL2
  ];
}
