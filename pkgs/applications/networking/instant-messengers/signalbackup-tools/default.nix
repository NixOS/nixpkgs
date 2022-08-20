{ lib, stdenv, fetchFromGitHub, fetchpatch, openssl, sqlite }:

stdenv.mkDerivation rec {
  pname = "signalbackup-tools";
  version = "20220810";

  src = fetchFromGitHub {
    owner = "bepaald";
    repo = pname;
    rev = version;
    sha256 = "sha256-z/RAvNUss9rNuBQvxjJQl66ZMrlxvmS9at8L/vSG0XU=";
  };

  # TODO: Remove when updating to next release.
  patches = [
    (fetchpatch {
      name = "fix-platform-checks.patch";
      url = "https://github.com/bepaald/signalbackup-tools/compare/20220810..a81baf25b6ba63da7d30d9a239e5b4bbc8d1ab4f.patch";
      sha256 = "sha256-i7fuPBil8zB+V3wHHdcbmP79OZoTfG2ZpXPQ3m7X06c=";
    })
  ];

  postPatch = ''
    patchShebangs BUILDSCRIPT_MULTIPROC.bash44
  '';

  buildInputs = [ openssl sqlite ];

  # Manually define `CXXFLAGS` and `LDFLAGS` on Darwin since the build scripts includes flags
  # that don't work on Darwin.
  buildPhase = ''
    runHook preBuild
  '' + lib.optionalString stdenv.isDarwin ''
    export CXXFLAGS="-Wall -Wextra -Wshadow -Wold-style-cast -Woverloaded-virtual -pedantic -O3"
    export LDFLAGS="-Wall -Wextra -O3"
  '' + ''
    ./BUILDSCRIPT_MULTIPROC.bash44
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp signalbackup-tools $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to work with Signal Backup files";
    homepage = "https://github.com/bepaald/signalbackup-tools";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.malo ];
    platforms = platforms.all;
  };
}
