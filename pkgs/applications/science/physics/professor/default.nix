{ lib, stdenv, fetchurl, eigen, makeWrapper, python3 }:

stdenv.mkDerivation rec {
  pname = "professor";
  version = "2.3.3";

  src = fetchurl {
    name = "Professor-${version}.tar.gz";
    url = "https://professor.hepforge.org/downloads/?f=Professor-${version}.tar.gz";
    sha256 = "17q026r2fpfxzf74d1013ksy3a9m57rcr2q164n9x02ci40bmib0";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile \
      --replace '-shared -o' '-shared -install_name "$(out)/$@" -o'
  '';

  nativeBuildInputs = [ python3.pkgs.cython makeWrapper ];
  buildInputs = [ python3 eigen ];
  propagatedBuildInputs = with python3.pkgs; [ iminuit numpy matplotlib yoda ];

  CPPFLAGS = [ "-I${eigen}/include/eigen3" ];
  PREFIX = placeholder "out";

  postInstall = ''
    for prog in "$out"/bin/*; do
      wrapProgram "$prog" --set PYTHONPATH "$PYTHONPATH:$(toPythonPath "$out")"
    done
  '';

  doInstallCheck = true;
  installCheckTarget = "check";

  meta = with lib; {
    description = "Tuning tool for Monte Carlo event generators";
    homepage = "https://professor.hepforge.org/";
    license = licenses.unfree; # no license specified
    maintainers = [ maintainers.veprbl ];
    platforms = platforms.unix;
  };
}
