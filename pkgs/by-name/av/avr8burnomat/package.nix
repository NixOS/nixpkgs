{
  lib,
  stdenv,
  fetchurl,
  unzip,
  runtimeShell,
}:

stdenv.mkDerivation rec {
  pname = "avr8-burn-omat";
  version = "2.1.2";

  src = fetchurl {
    url = "http://avr8-burn-o-mat.aaabbb.de/AVR8_Burn-O-Mat_${
      lib.replaceStrings [ "." ] [ "_" ] version
    }.zip";
    sha256 = "02k0fd0cd3y1yqip36wr3bkxbywp8913w4y7jdg6qwqxjnii58ln";
  };

  nativeBuildInputs = [ unzip ];

  # move to nix-support to not create that many symlinks..
  # TODO burnomat tries to read /usr/local/etc/avrdude.conf (but you can edit it within the settings dialog)
  installPhase = ''
    mkdir -p $out/{nix-support,bin}
    mv *.jar license_gpl-3.0.txt lib *.xml *.png $out/nix-support
    cat >> $out/bin/avr8-burn-omat << EOF
    #!${runtimeShell}
    cd $out/nix-support; exec java -jar AVR8_Burn_O_Mat.jar
    EOF
    chmod +x $out/bin/avr8-burn-omat
  '';

  meta = with lib; {
    description = "GUI tool for avrdude";
    mainProgram = "avr8-burn-omat";
    homepage = "http://avr8-burn-o-mat.aaabbb.de/avr8_burn_o_mat_avrdude_gui_en.html";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3;
    platforms = platforms.all;
  };
}
