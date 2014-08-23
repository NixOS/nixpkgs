{ stdenv, fetchurl, cmake, qt4, gettext
, kdelibs, kdebase_workspace, perl
, openssl, phonon, automoc4
, libX11, libXext, libXft
, unrar, p7zip, par2cmdline, coreutils
}:

let version = "0.8.4";
    name = "kwooty-${version}";
in stdenv.mkDerivation {
  inherit name;
  
  src = fetchurl {
    url = "mirror://sourceforge/kwooty/${name}.tar.gz";
    sha256 = "0i3zmh7y52n5k0yn3xc6zjpjz75f48nly40n394i6sxy89psgfc2";
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
    [ stdenv perl cmake qt4 gettext automoc4 openssl
      kdelibs kdebase_workspace phonon
      libX11 libXext libXft
    ];
                  
  meta = {
    description = "Binary news reader of KDE";
  };
}
