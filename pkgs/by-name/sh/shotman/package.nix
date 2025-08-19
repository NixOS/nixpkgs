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
  version = "0.4.10";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "shotman";
    rev = "v${version}";
    hash = "sha256-j9HNqRJnGiy720uS0zC6Tt1WjF4b6+XqPEMTqTEOD6w=";
  };

  cargoHash = "sha256-+PpNf79yz5e5Mr6HAqE9Wg/0S8JO4rWrMT7JtQYAWPs=";

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
