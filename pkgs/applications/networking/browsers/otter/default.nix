{ stdenv, cmake, openssl, gst_all_1, fetchFromGitHub
, qtbase, qtmultimedia, qtwebengine
, version ? "0.9.94"
, sourceSha ? "19mfm0f6qqkd78aa6q4nq1y9gnlasqiyk68zgqjp1i03g70h08k5"
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
