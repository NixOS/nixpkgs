{
  dmidecode,
  dpkg,
  fetchurl,
  lib,
  libndctl,
  makeWrapper,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "memory-viewer";
  version = "1.0.0";

  src = fetchurl {
    url = "https://memory-viewer-bucket.s3.amazonaws.com/releases/${version}/mvmv-${version}-dragonfruit.x86_64.deb";
    hash = "sha256-lOS4hTTVKxs+wlTKVPQdpb4o7os9N7dLGbKglmnzmJQ=";
  };

  nativeBuildInputs = [
    makeWrapper
    dpkg
  ];

  installPhase = ''
    mkdir $out
    mv usr/bin $out/
    wrapProgram $out/bin/mvmv \
      --prefix PATH : "${lib.makeBinPath [ libndctl dmidecode ]}"
  '';

  meta = {
    description = "Comprehensive Linux memory analysis tool";
    homepage = "https://memverge.com/memoryviewer/";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.vinnymeller ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "mvmv";
  };
}
