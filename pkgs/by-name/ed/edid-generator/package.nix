{
  lib,
  stdenv,
  fetchFromGitHub,
  dos2unix,
  hexdump,
  v4l-utils,
  zsh,
}:

# Usage:
#   hardware.firmware = [(edid-generator.overrideAttrs {
#     clean = true;
#     modelines = ''
#       Modeline "PG278Q_60"      241.50   2560 2608 2640 2720   1440 1443 1448 1481   -hsync +vsync
#       Modeline "PG278Q_120"     497.75   2560 2608 2640 2720   1440 1443 1448 1525   +hsync -vsync
#       Modeline "U2711_60"       241.50   2560 2600 2632 2720   1440 1443 1448 1481   -hsync +vsync
#     '';
#   })];

stdenv.mkDerivation {
  pname = "edid-generator";
  version = "master-2023-11-20";

  # so `hardware.firmware` doesn't compress it
  compressFirmware = false;

  src = fetchFromGitHub {
    owner = "akatrevorjay";
    repo = "edid-generator";
    rev = "476a016d8b488df749bf6d6efbf7b9fbfb2e3cb8";
    sha256 = "sha256-UGxze273VB5cQDWrv9X/Lam6WbOu9U3bro8GcVbEvws=";
  };

  nativeBuildInputs = [
    dos2unix
    hexdump
    v4l-utils
    zsh
  ];

  postPatch = ''
    patchShebangs modeline2edid
  '';

  passAsFile = [ "modelines" ];
  clean = false;
  modelines = "";

  configurePhase = ''
    runHook preConfigure

    test "$clean" != 1 || rm *x*.S
    ./modeline2edid - <"$modelinesPath"

    for file in *.S ; do
      echo "--- generated file: $file"
      cat "$file"
    done
    make clean

    runHook postConfigure
  '';

  buildPhase = ''
    make all
  '';

  doCheck = true;
  checkPhase = ''
    for file in *.bin ; do
      echo "validating $file"
      edid-decode <"$file"
    done
  '';

  installPhase = ''
    install -Dm 444 *.bin -t "$out/lib/firmware/edid"
  '';

  meta = {
    description = "Hackerswork to generate an EDID blob from given Xorg Modelines";
    homepage = "https://github.com/akatrevorjay/edid-generator";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      flokli
      nazarewk
    ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/edid-generator.x86_64-darwin
  };
}
