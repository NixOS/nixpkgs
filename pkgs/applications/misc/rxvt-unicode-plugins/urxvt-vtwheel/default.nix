{ stdenv, fetchgit, perl }:

stdenv.mkDerivation {

  name = "rxvt-unicode-vtwheel-0.3.2";

  src = fetchgit {
   url = "https://aur.archlinux.org/urxvt-vtwheel.git";
   rev = "36d3e861664aeae36a45f96100f10f8fe2218035";
   sha256 = "1h3vrsbli5q9kr84j5ijbivlhpwlh3l8cv233pg362v2zz4ja8i7";
  };
  
  installPhase = ''
    sed -i 's|#! perl|#! ${perl}/bin/perl|g' vtwheel
    mkdir -p $out/lib/urxvt/perl
    cp vtwheel $out/lib/urxvt/perl
  '';

  meta = with stdenv.lib; {
    description = "Pass mouse wheel commands to secondary screens (screen, less, nano, etc)";
    homepage = https://aur.archlinux.org/packages/urxvt-vtwheel;
    license = licenses.mit;
    maintainers = with maintainers; [ danbst ];
    platforms = with platforms; unix;
  };
  
}
