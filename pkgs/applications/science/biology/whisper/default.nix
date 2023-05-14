{ lib, stdenv, fetchFromGitHub, fetchurl }:

stdenv.mkDerivation rec {
  pname = "whisper";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "refresh-bio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wpx1w1mar2d6zq2v14vy6nn896ds1n3zshxhhrrj5d528504iyw";
  };

  preConfigure = ''
    cd src

    # disable default static linking
    sed -i 's/ -static / /' makefile
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin whisper whisper-index
    runHook postInstall
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Short read sequence mapper";
    license = licenses.gpl3;
    homepage = "https://github.com/refresh-bio/whisper";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
  };
}
