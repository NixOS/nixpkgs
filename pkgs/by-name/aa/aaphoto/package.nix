{
  lib,
  stdenv,
  fetchFromGitHub,
  jasper,
  libpng,
  libjpeg,
  zlib,
  llvmPackages,
}:

stdenv.mkDerivation {
  pname = "aaphoto";
  version = "0.45";

  src = fetchFromGitHub {
    owner = "log69";
    repo = "aaphoto";
    rev = "581b3fad60382bdd36356155112559f731e31be3";
    hash = "sha256-PcvZ6v8vcZcrSn9EJ0CqxYz9gOJXlcVIkLLzFik0Pec=";
  };

  nativeBuildInputs = lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  buildInputs = [
    jasper
    libpng
    libjpeg
    zlib
  ];

  postInstall = ''
    install -Dm644 NEWS README REMARKS TODO -t $out/share/doc/aaphoto
  '';

  meta = {
    homepage = "https://github.com/log69/aaphoto";
    description = "Free and open source automatic photo adjusting software";
    longDescription = ''
      Auto Adjust Photo tries to give a solution for the automatic color
      correction of photos. This means setting the contrast, color balance,
      saturation and gamma levels of the image by analization.

      This can be a solution for those kind of users who are not able to manage
      and correct images with complicated graphical softwares, or just simply
      don't intend to spend a lot of time with manually correcting the images
      one-by-one.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
    mainProgram = "aaphoto";
  };
}
