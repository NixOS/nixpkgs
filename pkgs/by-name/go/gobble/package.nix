{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libxcb,
  installShellFiles,
  pandoc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gobble";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "EmperorPenguin18";
    repo = "gobble";
    rev = finalAttrs.version;
    hash = "sha256-g4154Axvjp9jbE0lvMeNGM+v2UxkAsZqt9kPv5bhVK8=";
  };

  cargoHash = "sha256-DnIZTeRyxhmVK2uB21ScPiEyL4k9kAWfVoLNIAM9P68=";

  buildInputs = [ libxcb ];
  nativeBuildInputs = [
    pandoc
    installShellFiles
  ];

  postInstall = ''
    pandoc gobble.1.md -s -t man -o gobble.1
    installManPage gobble.1
  '';

  meta = {
    description = "Rust rewrite of Devour";
    homepage = "https://github.com/EmperorPenguin18/gobble";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ vuimuich ];
    platforms = lib.platforms.linux;
    mainProgram = "gobble";
  };
})
