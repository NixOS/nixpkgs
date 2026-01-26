{
  lib,
  stdenv,
  fetchFromGitHub,
  mkfontscale,
  fonttosfnt,
}:

stdenv.mkDerivation rec {
  pname = "cherry";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "turquoise-hexagon";
    repo = "cherry";
    tag = version;
    sha256 = "13zkxwp6r6kcxv4x459vwscr0n0sik4a3kcz5xnmlpvcdnbxi586";
  };

  nativeBuildInputs = [
    fonttosfnt
    mkfontscale
  ];

  buildPhase = ''
    patchShebangs make.sh
    ./make.sh
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/misc
    cp *.otb $out/share/fonts/misc

    # create fonts.dir so NixOS xorg module adds to fp
    mkfontdir $out/share/fonts/misc
  '';

  meta = {
    description = "cherry font";
    homepage = "https://github.com/turquoise-hexagon/cherry";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
