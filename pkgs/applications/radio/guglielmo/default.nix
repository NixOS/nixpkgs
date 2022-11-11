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
  version = "0.4";

  src = fetchFromGitHub {
    owner = "marcogrecopriolo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-djBQTYbpgPFBtQZ9fZBpECP20RxB49AdxLbq8mUU6rg=";
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
