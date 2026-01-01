{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  glib,
  cmake,
  json-glib,
  polkit,
  gtk3,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cmd-polkit";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "OmarCastro";
    repo = "cmd-polkit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oQaGV/ROP9YFyL8owduKOZLjqyx9D35xH67gNKECduQ=";
  };

  nativeBuildInputs = [
    meson
    cmake
    pkg-config
    ninja
  ];

  buildInputs = [
    json-glib
    glib
    polkit
    gtk3
  ];

<<<<<<< HEAD
  meta = {
    description = "Easily create polkit authentication agents by using commands";
    homepage = "https://github.com/OmarCastro/cmd-polkit";
    changelog = "https://github.com/OmarCastro/cmd-polkit/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "cmd-polkit-agent";
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Easily create polkit authentication agents by using commands";
    homepage = "https://github.com/OmarCastro/cmd-polkit";
    changelog = "https://github.com/OmarCastro/cmd-polkit/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ daru-san ];
    mainProgram = "cmd-polkit-agent";
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
