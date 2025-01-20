{
  lib,
  rustPlatform,
  fetchFromGitHub,
  xorg,
  installShellFiles,
  pandoc,
}:

rustPlatform.buildRustPackage rec {
  pname = "gobble";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "EmperorPenguin18";
    repo = pname;
    rev = version;
    hash = "sha256-g4154Axvjp9jbE0lvMeNGM+v2UxkAsZqt9kPv5bhVK8=";
  };

  cargoHash = "sha256-5xsMLOYTKQc1bHHQsk9L4rHMVNBFOzIMxD+1qaMaNbQ=";

  buildInputs = [ xorg.libxcb ];
  nativeBuildInputs = [
    pandoc
    installShellFiles
  ];

  postInstall = ''
    pandoc gobble.1.md -s -t man -o gobble.1
    installManPage gobble.1
  '';

  meta = {
    description = "gobbles your terminal";
    homepage = "https://github.com/EmperorPenguin18/gobble";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ vuimuich ];
    platforms = lib.platforms.linux;
    mainProgram = "gobble";
  };
}
