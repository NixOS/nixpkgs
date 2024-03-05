{ lib, stdenv, fetchFromGitHub, fetchpatch, fetchurl }:

stdenv.mkDerivation rec {
  pname = "whisper";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "refresh-bio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wpx1w1mar2d6zq2v14vy6nn896ds1n3zshxhhrrj5d528504iyw";
  };

  patches = [
    # gcc-13 compatibility fixes:
    #   https://github.com/refresh-bio/Whisper/pull/17
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/refresh-bio/Whisper/commit/d67e110dd6899782e4687188f6b432494315b0b4.patch";
      hash = "sha256-Z8GrkUMIKO/ccEdwulQh+WUox3CEckr6NgoBSzYvfuw=";
    })
  ];

  preConfigure = ''
    cd src

    # disable default static linking
    sed -i 's/ -static / /' makefile
  '';

  enableParallelBuilding = true;

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
