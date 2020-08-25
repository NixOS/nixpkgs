{ stdenv, pkgs, makeWrapper, nodejs }:

let
  pname = "hotel";
  version = "0.8.7";

  nodePkgs = (import ./hotel.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  });

  hotel = nodePkgs."hotel-git+https://github.com/typicode/hotel.git#v${version}";

  myHotel = hotel.overrideAttrs(oa: oa // {
    preRebuild = ''
      ${nodejs}/bin/node node_modules/babel-cli/bin/babel.js src -d lib --copy-files --ignore src/app
    '';
  });

  src = myHotel.src;
in

stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin

    makeWrapper ${myHotel}/bin/hotel $out/bin/hotel
  '';

  meta = with stdenv.lib; {
    description = "Local development environment with domains and proxying for docker";
    homepage = "https://github.com/typicode/hotel";
    license = licenses.mit;
    maintainers = [ maintainers.etu ];
    platforms = platforms.linux;
  };
}
