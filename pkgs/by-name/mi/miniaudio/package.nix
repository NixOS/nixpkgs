{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "miniaudio";
  version = "0.11.22";

  src = fetchFromGitHub {
    owner = "mackron";
    repo = "miniaudio";
    rev = finalAttrs.version;
    hash = "sha256-o/7sfBcrhyXEakccOAogQqm8dO4Szj1QSpaIHg6OSt4=";
  };

  postInstall = ''
    mkdir -p $out/include
    mkdir -p $out/lib/pkgconfig

    cp $src/miniaudio.h $out/include
    ln -s $out/include/miniaudio.h $out

    cp -r $src/extras $out/

    cat <<EOF >$out/lib/pkgconfig/miniaudio.pc
    prefix=$out
    includedir=$out/include

    Name: miniaudio
    Description: An audio playback and capture library in a single source file.
    Version: $version
    Cflags: -I$out/include
    Libs: -lm -lpthread -latomic
    EOF
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Single header audio playback and capture library written in C";
    homepage = "https://github.com/mackron/miniaudio";
    changelog = "https://github.com/mackron/miniaudio/blob/${finalAttrs.version}/CHANGES.md";
    license = with licenses; [
      unlicense # or
      mit0
    ];
    maintainers = [ maintainers.jansol ];
    pkgConfigModules = [ "miniaudio" ];
    platforms = platforms.all;
  };
})
