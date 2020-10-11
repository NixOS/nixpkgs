{ lib, stdenv, fetchFromGitHub, python2, makeWrapper }:

let pythonEnv = python2.withPackages(ps: [ ps.pyGtkGlade]);
in stdenv.mkDerivation rec {
  pname   = "fslint";
  version = "2.46";

  src = fetchFromGitHub {
    owner  = "pixelb";
    repo   = "fslint";
    rev    = version;
    sha256 = "048pc1rsslbsrfchl2wmdd4hpa2gycglib7kdx8vqs947zcm0sfv";
  };

  buildInputs = [
    pythonEnv makeWrapper
  ];

  prePatch = ''
    substituteInPlace fslint-gui --replace "liblocation=os.path.dirname(os.path.abspath(sys.argv[0]))" "liblocation='$out'"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp * -R $out/
    cp fslint-gui $out/bin/fslint

    wrapProgram "$out/bin/fslint" \
      --prefix PYTHONPATH : "${pythonEnv.interpreter}"
    runHook postInstall
  '';

  meta = with lib; {
    description = "A utility to find and clean various forms of lint on a filesystem";
    homepage = "https://www.pixelbeat.org/fslint/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.dasj19 ];
    platforms = platforms.unix;
  };
}
