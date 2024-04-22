{ lib, mkDerivation, fetchFromGitHub, cmake, pkg-config
, airspy
, rtl-sdr
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
  version = "0.5";

  src = fetchFromGitHub {
    owner = "marcogrecopriolo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W+KTwtxbTDrtONmkw95gXT28n3k9KS364WOzLLJdGLM=";
  };

  postInstall = ''
    mv $out/linux-bin $out/bin
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    airspy
    rtl-sdr
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
    patchelf --add-rpath "${airspy}/lib:${rtl-sdr}/lib" $out/bin/.guglielmo-wrapped
  '';

  meta = with lib; {
    description = "Qt based FM / Dab tuner";
    mainProgram = "guglielmo";
    homepage = "https://github.com/marcogrecopriolo/guglielmo";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.markuskowa ];
    platforms =  platforms.linux;
  };
}
