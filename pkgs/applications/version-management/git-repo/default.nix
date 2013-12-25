{ stdenv, fetchurl, python }:

stdenv.mkDerivation {
  name = "git-repo-1.19";
  src = fetchurl {
    url = "https://git-repo.googlecode.com/files/repo-1.19";
    sha1 = "e48d46e36194859fe8565e8cbdf4c5d1d8768ef3";
  };

  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    install $src $out/bin/repo
  '';

  meta = {
    homepage = "http://source.android.com/source/downloading.html";
    description = "Android's repo management tool";
  };
}