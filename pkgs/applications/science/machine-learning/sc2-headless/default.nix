{ stdenv
, lib
, fetchurl
, unzip
, licenseAccepted ? false
}:

if !licenseAccepted then throw ''
    You must accept the Blizzard® Starcraft® II AI and Machine Learning License at
    https://blzdistsc2-a.akamaihd.net/AI_AND_MACHINE_LEARNING_LICENSE.html
    by setting nixpkgs config option 'sc2-headless.accept_license = true;'
  ''
else assert licenseAccepted;
stdenv.mkDerivation rec {
  version = "3.17";
  name = "sc2-headless-${version}";

  src = fetchurl {
    url = "https://blzdistsc2-a.akamaihd.net/Linux/SC2.${version}.zip";
    sha256 = "1biyxpf7n95hali1pw30h91rhzrj6sbwrx6s52d00mlnwdhmf2v0";
  };

  unpackCmd = ''
    unzip -P 'iagreetotheeula' $curSrc
  '';

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out
    cp -r . "$out"
    rm -r $out/Libs
  '';

  preFixup = ''
    find $out -type f -print0 | while IFS=''' read -d ''' -r file; do
      isELF "$file" || continue
      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath ${lib.makeLibraryPath [stdenv.cc.cc stdenv.cc.libc]} \
        "$file"
    done
  '';

  meta = {
    platforms = stdenv.lib.platforms.linux;
    description = "Starcraft II headless linux client for machine learning research";
    license = {
      fullName = "BLIZZARD® STARCRAFT® II AI AND MACHINE LEARNING LICENSE";
      url = "https://blzdistsc2-a.akamaihd.net/AI_AND_MACHINE_LEARNING_LICENSE.html";
      free = false;
    };
  };
}
