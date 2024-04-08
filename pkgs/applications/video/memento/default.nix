{ lib
, stdenv
, fetchFromGitHub
, cmake
, qtbase
, qtx11extras ? null # qt5 only
, wrapQtAppsHook

# before that => zeal
, sqlite
, json_c
, mecab
, libzip
, mpv
, yt-dlp
# optional
, makeWrapper}:

let
  isQt5 = lib.versions.major qtbase.version == "5";

in
stdenv.mkDerivation (finalAttrs: {
  pname = "memento";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "ripose-jp";
    repo = "Memento";
    rev = "v${finalAttrs.version}";
    hash = "sha256-55VvT7pHN0/HqxM4vMDQDgUwkVmO/8aOEOye8jcFzgI=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    sqlite
    json_c
    libzip
    mecab
  ] ++ lib.optionals isQt5 [ qtx11extras ];

  propagatedBuildInputs = [ mpv  ];

  preFixup = ''
     wrapProgram "$out/bin/memento" \
       --prefix PATH : "${yt-dlp}/bin" \
  '';

  meta = with lib; {
    description = "An mpv-based video player for studying Japanese";
    homepage = "https://ripose-jp.github.io/Memento/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ teto ];
    platforms = platforms.linux;
    mainProgram = "memento";
  };
})

