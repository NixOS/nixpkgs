{ stdenv, fetchurl, gcc, cmake, qt4, gettext
, kdelibs, kdebase_workspace, perl
, openssl, phonon, automoc4
, libX11, libXext, libXft
, unrar, p7zip, par2cmdline, coreutils
}:

let version = "0.8.0";
    name = "kwooty-${version}";
in stdenv.mkDerivation {
  inherit name;
  
  src = fetchurl {
    url = "mirror://sourceforge/kwooty/${name}.tar.gz";
    sha256 = "bb50fb9b3d6c973f2abee62cfc11a7086900a4b676c12bf4e0a2adc170a977fc";
  };

  patches = [ ./searchPath.patch ];

  postPatch = ''
    echo "Changing paths to archive utilities to the nix store";
    substituteInPlace "src/utility.cpp" \
      --replace "/usr/bin/unrar" "${unrar}/bin" \
      --replace "/usr/bin/unpar" "${par2cmdline}/bin" \
      --replace "/usr/bin/7z" "${p7zip}/bin" \
      --replace "/usr/bin/nice" "${coreutils}/bin/nice"
  '';

  buildInputs =
    [ gcc perl cmake qt4 gettext automoc4 openssl
      kdelibs kdebase_workspace phonon
      libX11 libXext libXft
    ];
                  
  meta = with stdenv.lib; {
    description = "Binary news reader for KDE";
  };
}
