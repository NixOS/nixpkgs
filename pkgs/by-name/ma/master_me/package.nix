{
  lib,
  stdenv,
  fetchFromGitHub,
  libGL,
  libX11,
  libXext,
  libXrandr,
  pkg-config,
  python3,
}:
stdenv.mkDerivation rec {
  pname = "master_me";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "trummerschlunk";
    repo = "master_me";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-eesMXxRcCgzhSQ+WUqM00EuKYhFxysjH+RWKHKGYzUM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libGL
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libX11
    libXext
    libXrandr
  ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs ./dpf/utils/
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/trummerschlunk/master_me";
    description = "Automatic mastering plugin for live streaming, podcasts and internet radio";
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # error: no type or protocol named 'NSPasteboardType'
    license = lib.licenses.gpl3Plus;
=======
  meta = with lib; {
    homepage = "https://github.com/trummerschlunk/master_me";
    description = "Automatic mastering plugin for live streaming, podcasts and internet radio";
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # error: no type or protocol named 'NSPasteboardType'
    license = licenses.gpl3Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "master_me";
  };
}
