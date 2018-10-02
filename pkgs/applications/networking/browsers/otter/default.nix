{ stdenv, cmake, fetchFromGitHub
, qtbase, qtmultimedia, qtwebengine
, version ? "0.9.99.3"
, sourceSha ? "0dkismjs3daz5afx6s5arwvynsw5qpvv2rqbzvmpihn6khnhap55"
}:
stdenv.mkDerivation {
  name = "otter-browser-${version}";

  src = fetchFromGitHub {
    owner = "OtterBrowser";
    repo = "otter-browser";
    rev = "v${version}";
    sha256 = sourceSha;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase qtmultimedia qtwebengine ];

  meta = with stdenv.lib; {
    license = licenses.gpl3Plus;
    description = "Browser aiming to recreate the best aspects of the classic Opera (12.x) UI using Qt5";
    maintainers = with maintainers; [ lheckemann ];
  };
}
