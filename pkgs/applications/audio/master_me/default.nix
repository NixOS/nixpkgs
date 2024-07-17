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
  Cocoa,
}:
stdenv.mkDerivation rec {
  pname = "master_me";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "trummerschlunk";
    repo = "master_me";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-FG3X1dOF9KRHHSnd5/zP+GrYCB2O0y+tnI5/l9tNhyE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      libGL
      python3
    ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa ]
    ++ lib.optionals stdenv.isLinux [
      libX11
      libXext
      libXrandr
    ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs ./dpf/utils/
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://github.com/trummerschlunk/master_me";
    description = "automatic mastering plugin for live streaming, podcasts and internet radio";
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.all;
    broken = stdenv.isDarwin; # error: no type or protocol named 'NSPasteboardType'
    license = licenses.gpl3Plus;
    mainProgram = "master_me";
  };
}
