{
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "meletrix-udev-rules";
  version = "0-unstable-2023-10-20";

  src = [./meletrix.rules];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    install -Dpm644 $src $out/lib/udev/rules.d/70-meletrix.rules
  '';

  meta = with lib; {
    description = "udev rules to configure Meletrix keyboards";
    license = licenses.cc0;
    maintainers = with maintainers; [Scrumplex];
    platforms = platforms.linux;
  };
}
