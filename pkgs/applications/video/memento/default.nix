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
  version = "v1.1.0";

  src = fetchFromGitHub {
    owner = "ripose-jp";
    repo = "Memento";
    rev = finalAttrs.version;
    hash = "sha256-29AzQ+Z2PNs65Tvmt2Z5Ra2G3Yhm4LVBpAqvnSsnE0Y=";
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
  };
})

