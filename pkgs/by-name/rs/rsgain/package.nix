{ lib
  , stdenv
  , cmake
  , fetchFromGitHub
  , libebur128
  , taglib
  , ffmpeg
  , inih
  , fmt
  , pkg-config
  , zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rsgain";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "complexlogic";
    repo = finalAttrs.pname;
    rev = "v" + finalAttrs.version;
    hash = "sha256-AiNjsrwTF6emcwXo2TPMbs8mLavGS7NsvytAppMGKfY=";
  };

  buildInputs = [ ffmpeg inih taglib libebur128 zlib fmt ];
  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "A ReplayGain 2.0 command line utility";
    homepage = "https://github.com/complexlogic/rsgain";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.incrediblelaser ];
  };
})
