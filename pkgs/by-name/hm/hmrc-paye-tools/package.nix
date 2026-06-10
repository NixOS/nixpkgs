{ lib
, stdenv
, fetchurl
, buildFHSEnv
, unzip
}:

let
  version = "24.1.24086.542";

  installer = stdenv.mkDerivation rec {
    name = "hmrc-paye-tools-installer";
    inherit version;

    src = fetchurl {
      url = "https://www.gov.uk/government/uploads/uploaded/hmrc/payetools-rti-${version}-linux.zip";
      hash = "sha256-QOW6Loqg001AcqWX/TOH6wvI2uAY4qNyFvQzCVEe8VU=";
    };

    dontUnpack = true;
    dontInstall = true;

    buildInputs = [ unzip ];

    buildPhase = ''
      mkdir -p $out/bin
      unzip $src -d $out/bin
      chmod +x $out/bin/*
    '';
  };

  installerFHS = buildFHSEnv {
    name = "hmrc-paye-tools-installer-fhs";
    targetPkgs = pkgs: [ pkgs.glibc ];
    runScript = "${installer}/bin/payetools-rti-${version}-linux";
  };

  package = stdenv.mkDerivation {
    name = "hmrc-paye-tools";
    inherit version;

    dontUnpack = true;

    buildPhase = ''
      ${installerFHS}/bin/hmrc-paye-tools-installer-fhs --mode unattended --prefix prefix --check_for_updates 0
      mv prefix $out
    '';
  };
in buildFHSEnv {
  name = "hmrc-paye-tools-fhs";

  targetPkgs = pkgs: (with pkgs; [
    glibc
    zlib
    fontconfig
    glib
    libpng
    freetype
    xorg.libSM
    xorg.libICE
    xorg.libXrender
    xorg.libXext
    xorg.libX11
    xorg.libXt
    xorg.libXau
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
    sqlite
    libGL
    gtk2
  ]);
  runScript = "${package}/rti.linux";

  meta = with lib; {
    description = "HMRC Basic PAYE Tools";
    homepage = "https://www.gov.uk/basic-paye-tools";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
