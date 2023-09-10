{ lib
, fetchFromGitHub
, rustPlatform
, fontconfig
, pkg-config
, wayland
, libxkbcommon
, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname = "kickoff";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "j0ru";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AolJXFolMEwoK3AtC93naphZetytzRl1yI10SP9Rnzo=";
  };

  cargoHash = "sha256-Twg2C29OwXfCK/rYXnyjbhmCClnsFHz8le9h4AmzXfA=";

  libPath = lib.makeLibraryPath [
    wayland
    libxkbcommon
  ];

  buildInputs = [ fontconfig ];
  nativeBuildInputs = [ makeWrapper pkg-config ];

  postInstall = ''
    wrapProgram "$out/bin/kickoff" --prefix LD_LIBRARY_PATH : "${libPath}"
  '';

  meta = with lib; {
    description = "Minimalistic program launcher";
    homepage = "https://github.com/j0ru/kickoff";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pyxels ];
    platforms = platforms.linux;
  };
}
