{ stdenv, fetchgit, rofi, wmctrl, xprop, xdotool}:

stdenv.mkDerivation rec {
  name = "rofi-pass-${version}";
  version = "2015-08-06";

  src = fetchgit {
    url = "https://github.com/carnager/rofi-pass";
    rev = "bb1f0d08cd438cc8da24e0341f902706a88e7aa5";
    sha256 = "1qx690vazwzzcg4yaghj9zd4c4md7bi6b90lgv4gwmdw74v6ghah";
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
