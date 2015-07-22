{ stdenv, fetchgit, rofi, wmctrl, xprop, xdotool}:

stdenv.mkDerivation rec {
  name = "rofi-pass-${version}";
  version = "2015-06-08";

  src = fetchgit {
    url = "https://github.com/carnager/rofi-pass";
    rev = "7e376b5ec64974c4e8478acf3ada8d111896f391";
    sha256 = "1ywsxdgy5m63a2f5vd7np2f1qffz7y95z7s1gq5d87s8xd8myadl";
  };

  buildInputs = [ rofi wmctrl xprop xdotool ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a $src/rofi-pass $out/bin/rofi-pass

    mkdir -p $out/share/doc/rofi-pass/
    cp -a $src/config.example $out/share/doc/rofi-pass/config.example
  '';

  meta = {
      description = "A script to make rofi work with password-store";
      homepage = https://github.com/carnager/rofi-pass;
      maintainers = [stdenv.lib.maintainers.hiberno];
  };
}
