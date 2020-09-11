{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "kak-prelude";
  version = "2020-03-15";

  src = fetchFromGitHub {
    owner = "alexherbo2";
    repo = "prelude.kak";
    rev = "05b2642b1e014bd46423f9d738cc38a624947b63";
    sha256 = "180p8hq8z7mznzd9w9ma5as3ijs7zbzcj96prcpswqg263a0b329";
  };

  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp -r rc $out/share/kak/autoload/plugins/auto-pairs
  '';

  meta = with stdenv.lib;
  { description = "Prelude of shell blocks for Kakoune.";
    homepage = "https://github.com/alexherbo2/prelude.kak";
    license = licenses.unlicense;
    maintainers = with maintainers; [ buffet ];
    platform = platforms.all;
  };
}
