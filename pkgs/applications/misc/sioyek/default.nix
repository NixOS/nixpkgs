{ lib
, stdenv
, installShellFiles
, fetchFromGitHub
, gumbo
, harfbuzz
, jbig2dec
, mujs
, mupdf
, openjpeg
, qt3d
, qtbase
, qmake
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "sioyek";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "ahrm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F71JXgYaWAye+nlSrZvGjJ4ucvHTx3tPZHRC5QI4QiU=";
  };

  buildInputs = [ gumbo harfbuzz jbig2dec mupdf mujs openjpeg qt3d qtbase ];

  nativeBuildInputs = [ installShellFiles wrapQtAppsHook qmake ];

  postPatch = ''
    substituteInPlace pdf_viewer/main.cpp \
      --replace "/usr/share/sioyek" "$out/share" \
      --replace "/etc/sioyek" "$out/etc"
  '';

  postInstall = ''
    install -Dm644 tutorial.pdf $out/share/tutorial.pdf
    cp -r pdf_viewer/shaders $out/share/
    install -Dm644 -t $out/etc/ pdf_viewer/{keys,prefs}.config
    installManPage resources/sioyek.1
  '';

  meta = with lib; {
    description = "Sioyek is a PDF viewer designed for reading research papers and technical books.";
    homepage = "https://sioyek.info/";
    changelog = "https://github.com/ahrm/sioyek/releases";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.podocarp ];
  };
}
