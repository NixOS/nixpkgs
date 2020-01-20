{ stdenv, lib, fetchFromGitHub, rofi, xdotool
, xsel, python3, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "rofimoji";
  version = "unstable-2020-01-12";

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofimoji";
    rev = "f211333bf90006c8742559a273e5eda26cf437ef";
    sha256 = "1msx4clnrp9lzp0ap8rsdhhacynhfbi797vpjp93jj62sb08ahnc";
  };

  dontBuild = true;

  buildInputs = [
    makeWrapper
    (python3.withPackages (pkgs: with pkgs; [
      ConfigArgParse
      pyxdg
    ]))
  ];

  installPhase = ''
    cp . -R $out
    makeWrapper $out/src/picker/rofimoji.py $out/bin/rofimoji \
      --prefix PATH : ${lib.makeBinPath [ xdotool xsel rofi ]}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/fdw/rofimoji;
    description = "A simple emoji picker for rofi";
    license = licenses.mit;
    maintainers = with maintainers; [ siers ];
  };
}
