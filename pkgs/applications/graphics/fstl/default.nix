{stdenv, fetchFromGitHub, qtbase, mesa_glu}:
stdenv.mkDerivation rec {
  name = "fstl-${version}";
  version = "0.9.3";

  buildInputs = [qtbase mesa_glu];

  prePatch = ''
    sed -i "s|/usr/bin|$out/bin|g" qt/fstl.pro
  '';

  preBuild = ''
    qmake qt/fstl.pro
  '';
  
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv fstl.app $out/Applications
  '';

  src = fetchFromGitHub {
    owner = "mkeeter";
    repo = "fstl";
    rev = "v" + version;
    sha256 = "1j0y9xbf0ybrrnsmfzgpyyz6bi98xgzn9ivani424j01vffns892";
  };

  meta = with stdenv.lib; {
    description = "The fastest STL file viewer";
    homepage = "https://github.com/mkeeter/fstl";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ tweber ];
  };
}
