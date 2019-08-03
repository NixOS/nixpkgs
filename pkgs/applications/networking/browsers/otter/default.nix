{ stdenv, cmake, fetchFromGitHub
, qtbase, qtmultimedia, qtwebengine, qtxmlpatterns
, version ? "1.0.01"
, sourceSha ? "1jw8bj3lcqngr0mqwvz1gf47qjxbwiyda7x4sm96a6ckga7pcwyb"
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

  buildInputs = [ qtbase qtmultimedia qtwebengine qtxmlpatterns ];

  meta = with stdenv.lib; {
    homepage = https://otter-browser.org;
    license = licenses.gpl3Plus;
    description = "Browser aiming to recreate the best aspects of the classic Opera (12.x) UI using Qt5";
    maintainers = with maintainers; [ lheckemann ];
  };
}
