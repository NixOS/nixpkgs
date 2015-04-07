{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "git-imerge-${version}";
  version = "0.7.0";

  src = fetchFromGitHub {
    repo = "git-imerge";
    owner = "mhagger";
    rev = version;
    sha256 = "09czjxgjbby54jx1v5m825k87v8g9g374hwv0r6ss48kv1ipvakq";
  };

  installPhase = ''
    mkdir -p $out/bin
    make install PREFIX=$out
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/mhagger/git-imerge;
    description = "Perform a merge between two branches incrementally";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.spwhitt ];
  };
}
