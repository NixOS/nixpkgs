{ lib
, stdenv
, fetchFromGitHub
, mpfr
}:

stdenv.mkDerivation rec {
  pname = "djent";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "dj-on-github";
    repo = "djent";
    rev = "${version}";
    hash = "sha256-inMh7l/6LlrVnIin+L+fj+4Lchk0Xvt09ngVrCuvphE=";
  };

  buildInputs = [ mpfr ];

  preBuild = ''
    sed -i s/gcc/${stdenv.cc.targetPrefix}gcc/g Makefile
  ''
  + lib.optionalString (!stdenv.hostPlatform.isx86_64) ''
    sed -i s/-m64//g Makefile
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    runHook preInstall
    install -D djent $out/bin/djent
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.deadhat.com/";
    description = ''
      A reimplementation of the Fourmilab/John Walker random number test program
      ent with several improvements
    '';
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ orichter thillux ];
  };
}
