{ lib, stdenv, fetchurl, dpkg, makeWrapper, coreutils, gawk, gnugrep, gnused, jre }:

with lib;

stdenv.mkDerivation rec {
  pname = "marvin";
<<<<<<< HEAD
  version = "23.4.0";
=======
  version = "22.13.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchurl {
    name = "marvin-${version}.deb";
    url = "http://dl.chemaxon.com/marvin/${version}/marvin_linux_${versions.majorMinor version}.deb";
<<<<<<< HEAD
    sha256 = "sha256-+jzGcuAcbXOwsyAL+Hr9Fas2vO2S8ZKSaZeCf/bnl7A=";
=======
    sha256 = "sha256-cZ9SFdKNURhcInM6zZNwoi+WyHAsGCeAgkfpAVi7GYE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  unpackPhase = ''
    dpkg-deb -x $src opt
  '';

  installPhase = ''
    wrapBin() {
      makeWrapper $1 $out/bin/$(basename $1) \
        --set INSTALL4J_JAVA_HOME "${jre}" \
        --prefix PATH : ${makeBinPath [ coreutils gawk gnugrep gnused ]}
    }
    cp -r opt $out
    mkdir -p $out/bin $out/share/pixmaps $out/share/applications
    for name in LicenseManager MarvinSketch MarvinView; do
      wrapBin $out/opt/chemaxon/marvinsuite/$name
      ln -s {$out/opt/chemaxon/marvinsuite/.install4j,$out/share/pixmaps}/$name.png
    done
    for name in cxcalc cxtrain evaluate molconvert mview msketch; do
      wrapBin $out/opt/chemaxon/marvinsuite/bin/$name
    done
    ${concatStrings (map (name: ''
      substitute ${./. + "/${name}.desktop"} $out/share/applications/${name}.desktop --subst-var out
    '') [ "LicenseManager" "MarvinSketch" "MarvinView" ])}
  '';

  meta = {
    description = "A chemical modelling, analysis and structure drawing program";
    homepage = "https://chemaxon.com/products/marvin";
    maintainers = with maintainers; [ fusion809 ];
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
