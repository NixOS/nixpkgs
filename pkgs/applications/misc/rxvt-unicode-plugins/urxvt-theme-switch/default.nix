{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  rev = "cfcbcc3dd5a5b09a3fec0f6a1fea95f4a36a48c4";
  name = "urxvt-theme-switch-2014-12-21_rev${builtins.substring 0 1 rev}";
  dontPatchShebangs = true;

  src = fetchFromGitHub {
    owner = "felixr";
    repo = "urxvt-theme-switch";
    inherit rev;
    sha256 = "0x27m1vdqprn3lqpwgxvffill7prmaj6j9rhgvkvi13mzl5wmlli";
  };

  installPhase = ''
    mkdir -p $out/lib/urxvt/perl
    sed -i -e "s|/usr/bin/env||" color-themes
    cp color-themes $out/lib/urxvt/perl
  '';

  meta = with stdenv.lib; {
    description = "urxvt plugin that allows to switch color themes during runtime";
    homepage = https://github.com/felixr/urxvt-theme-switch;
    license = "CCBYNC";
    maintainers = with maintainers; [ ];
    platforms = with platforms; unix;
  };
}
