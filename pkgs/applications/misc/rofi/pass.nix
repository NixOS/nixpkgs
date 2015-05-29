{ stdenv, fetchgit, wmctrl, xprop, xdotool}:

stdenv.mkDerivation rec {
  name = "rofi-${version}";
  version = "2015-05-29";

  src = fetchgit {
    url = "https://github.com/carnager/rofi-pass";
    rev = "92c26557ec4b0508c563d596291571bbef402899";
    sha256 = "17k9jmmckqaw75i0qsay2gc8mrjrs6jjfwfxaggspj912sflmjng";
  };

  buildInputs = [ wmctrl xprop xdotool ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a $src/rofi-pass $out/bin/rofi-pass

    mkdir -p $out/share/doc/rofi-pass/
    cp -a $src/config.example $out/share/doc/rofi-pass/config.example
  '';

  meta = {
      description = "Rofi script to work with password-store";
      homepage = https://github.com/carnager/rofi-pass;
      maintainers = [stdenv.lib.maintainers._1126];
  };
}
