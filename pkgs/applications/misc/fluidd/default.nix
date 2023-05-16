{ lib, stdenvNoCC, fetchurl, unzip }:

stdenvNoCC.mkDerivation rec {
  pname = "fluidd";
<<<<<<< HEAD
  version = "1.25.2";
=======
  version = "1.23.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchurl {
    name = "fluidd-v${version}.zip";
    url = "https://github.com/cadriel/fluidd/releases/download/v${version}/fluidd.zip";
<<<<<<< HEAD
    sha256 = "sha256-WlUTRmQ1RWI2HQ5Kn85q+/fzVnTsda2aqgTWRlA+5JY=";
=======
    sha256 = "sha256-od/RoxFjnOuyz7+D+avQJyJzpqpovzs+g4ErfyDJQpY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ unzip ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    mkdir fluidd
    unzip $src -d fluidd
  '';

  installPhase = ''
    mkdir -p $out/share/fluidd
    cp -r fluidd $out/share/fluidd/htdocs
  '';

  meta = with lib; {
    description = "Klipper web interface";
    homepage = "https://docs.fluidd.xyz";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
