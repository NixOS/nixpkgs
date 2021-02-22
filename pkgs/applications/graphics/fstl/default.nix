{ lib, stdenv, fetchFromGitHub, mkDerivation, qtbase, mesa_glu }:

mkDerivation rec {
  pname = "fstl";
  version = "0.9.4";

  buildInputs = [qtbase mesa_glu];

  prePatch = ''
    sed -i "s|/usr/bin|$out/bin|g" qt/fstl.pro
  '';

  preBuild = ''
    qmake qt/fstl.pro
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv fstl.app $out/Applications
  '';

  src = fetchFromGitHub {
    owner = "mkeeter";
    repo = "fstl";
    rev = "v" + version;
    sha256 = "028hzdv11hgvcpc36q5scf4nw1256qswh37xhfn5a0iv7wycmnif";
  };

  meta = with lib; {
    description = "The fastest STL file viewer";
    homepage = "https://github.com/mkeeter/fstl";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ tweber ];
  };
}
