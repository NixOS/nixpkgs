{ stdenv, cmake, openssl, gst_all_1, fetchFromGitHub
, qtbase, qtmultimedia, qtwebengine
, version ? "0.9.96"
, sourceSha ? "1xzfy3jjx9sskwwbk7l8hnwnjf8af62p4kjkydp0ld0j50apc39p"
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
