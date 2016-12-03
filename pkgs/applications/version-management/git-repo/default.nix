{ stdenv, fetchurl, python }:

stdenv.mkDerivation {
  name = "git-repo-1.23";
  src = fetchurl {
    # I could not find a versioned url for the 1.21 version. In case
    # the sha mismatches, check the homepage for new version and sha.
    url = "http://commondatastorage.googleapis.com/git-repo-downloads/repo";
    sha256 = "1i8xymxh630a7d5nkqi49nmlwk77dqn36vsygpyhri464qwz0iz1";
  };

  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    sed -e 's,!/usr/bin/env python,!${python}/bin/python,' < $src > $out/bin/repo
    chmod +x $out/bin/repo
  '';

  meta = {
    homepage = "http://source.android.com/source/downloading.html";
    description = "Android's repo management tool";
    platforms = stdenv.lib.platforms.unix;
  };
}
