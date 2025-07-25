{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  pkg-config,
  libxkbcommon,
  makeWrapper,
  slurp,
}:

rustPlatform.buildRustPackage rec {
  pname = "shotman";
  version = "0.4.7";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "shotman";
    rev = "v${version}";
    hash = "sha256-kf/qloCaptxPzPEgd8fkzTfgqsI/PC3KJfHpBQWadjQ=";
  };

  cargoHash = "sha256-ZL0dKvCX/cvMzJi05qPULlwWuUcXH/bY84sDH67UFHg=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [ libxkbcommon ];

  preFixup = ''
    wrapProgram $out/bin/shotman \
      --prefix PATH ":" "${lib.makeBinPath [ slurp ]}";
  '';

  meta = with lib; {
    description = "Uncompromising screenshot GUI for Wayland compositors";
    homepage = "https://git.sr.ht/~whynothugo/shotman";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      zendo
      fpletz
    ];
  };
}
