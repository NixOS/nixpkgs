{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dragon-drop";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "mwh";
    repo = "dragon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wqG6idlVvdN+sPwYgWu3UL0la5ssvymZibiak3KeV7M=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 ];

  makeFlags = [ "NAME=dragon-drop" ];
  installFlags = [ "PREFIX=${placeholder "out"}" ];
  postInstall = ''
    ln -s $out/bin/dragon-drop $out/bin/xdragon
  '';

  meta = {
    description = "Simple drag-and-drop source/sink for X or Wayland (called dragon in upstream)";
    homepage = "https://github.com/mwh/dragon";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      das_j
      taliyahwebb
    ];
    mainProgram = "dragon-drop";
    platforms = lib.platforms.linux;
  };
})
