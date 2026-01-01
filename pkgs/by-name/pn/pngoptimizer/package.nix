{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "pngoptimizer";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "hadrien-psydk";
    repo = "pngoptimizer";
    rev = "v${version}";
    sha256 = "1hbgf91vzx46grslfdx86smdvm6gs6lq9hpa3bax9xfbsknxi0i7";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 ];

  makeFlags = [
    "CONFIG=release"
    "DESTDIR=$(out)"
  ];

  postInstall = ''
    mv $out/usr/bin $out/bin
    mv $out/usr/share $out/share
    rmdir $out/usr
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://psydk.org/pngoptimizer";
    description = "PNG optimizer and converter";
    # https://github.com/hadrien-psydk/pngoptimizer#license-information
    license = with lib.licenses; [
=======
  meta = with lib; {
    homepage = "https://psydk.org/pngoptimizer";
    description = "PNG optimizer and converter";
    # https://github.com/hadrien-psydk/pngoptimizer#license-information
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      gpl2Only
      lgpl21Only
      zlib
    ];
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ smitop ];
    platforms = with lib.platforms; linux;
=======
    maintainers = with maintainers; [ smitop ];
    platforms = with platforms; linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
