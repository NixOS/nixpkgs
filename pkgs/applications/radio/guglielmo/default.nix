{ lib, mkDerivation, fetchFromGitHub, cmake, pkg-config
, airspy
, librtlsdr
, fdk_aac
, faad2
, fftwFloat
, libsndfile
, libsamplerate
, portaudio
, qtmultimedia
, qwt
} :

mkDerivation rec {
  pname = "guglielmo";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "marcogrecopriolo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s1iz9s0k897jayiwl3yr9ylpclw6bzcpmzhxqn0mkd7jhgfl4vx";
  };

  postInstall = ''
    mv $out/linux-bin $out/bin
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    airspy
    librtlsdr
    fdk_aac
    faad2
    fftwFloat
    libsndfile
    libsamplerate
    portaudio
    qtmultimedia
    qwt
  ];

  postFixup = ''
    # guglielmo opens SDR libraries at run time
    patchelf --add-rpath "${airspy}/lib:${librtlsdr}/lib" $out/bin/.guglielmo-wrapped
  '';

  meta = with lib; {
    description = "Qt based FM / Dab tuner";
    homepage = "https://github.com/marcogrecopriolo/guglielmo";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.markuskowa ];
    platforms =  platforms.linux;
  };
}
