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
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "j0ru";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9QupKpB3T/6gdGSeLjRknjPdgOzbfzEeJreIamWwpSw=";
  };

  cargoHash = "sha256-a7FZpMtgTdqpLV/OfgN4W4GpTJlkfEtPO7F//FmVA/s=";

  libPath = lib.makeLibraryPath [
    wayland
    libxkbcommon
  ];

  buildInputs = [ fontconfig libxkbcommon ];
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
