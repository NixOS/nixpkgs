{
  lib,
  stdenv,
  fetchFromGitHub,
  libpng,
  bison,
  flex,
  ffmpeg,
  icu,
}:

stdenv.mkDerivation rec {
  pname = "cfdg";
  version = "3.4.3";
  src = fetchFromGitHub {
    owner = "MtnViewJohn";
    repo = "context-free";
    rev = "Version${version}";
    sha256 = "sha256-a/HmB2AkhcibCxzHfiNjnUiYmz5hrfZVs7aZZu5IBIw=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];
  buildInputs = [
    libpng
    ffmpeg
    icu
  ];

  postPatch = ''
    sed -e "/YY_NO_UNISTD/a#include <stdio.h>" -i src-common/cfdg.l
    sed -e '1i#include <algorithm>' -i src-common/{cfdg,builder,ast}.cpp
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp cfdg $out/bin/

    mkdir -p $out/share/doc/${pname}-${version}
    cp *.txt $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = {
    description = "Context-free design grammar - a tool for graphics generation";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    homepage = "https://contextfreeart.org/";
    license = lib.licenses.gpl2Only;
    mainProgram = "cfdg";
  };
}
