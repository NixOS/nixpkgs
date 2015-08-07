{ stdenv, fetchgit, rofi, wmctrl, xprop, xdotool}:

stdenv.mkDerivation rec {
  name = "rofi-pass-${version}";
  version = "1.0";

  src = fetchgit {
    url = "https://github.com/carnager/rofi-pass";
    rev = "refs/tags/${version}";
    sha256 = "16k7bj5mf5alfks8mylp549q3lmpbxjsrsgyj7gibdmhjz768jz3";
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
