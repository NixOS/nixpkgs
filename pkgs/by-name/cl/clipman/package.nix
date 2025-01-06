{
  buildGoModule,
  fetchFromGitHub,
  lib,
  wl-clipboard,
  makeWrapper,
  installShellFiles,
}:

buildGoModule rec {
  pname = "clipman";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kuW74iUVLfIUWf3gaKM7IuMU1nfpU9SbSsfeZDbYGhY=";
  };

  vendorHash = "sha256-I1RWyjyOfppGi+Z5nvAei5zEvl0eQctcH8NP0MYSTbg=";

  outputs = [
    "out"
    "man"
  ];

  doCheck = false;

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  postInstall = ''
    wrapProgram $out/bin/clipman \
      --prefix PATH : ${lib.makeBinPath [ wl-clipboard ]}
    installManPage docs/*.1
  '';

  meta = {
    homepage = "https://github.com/chmouel/clipman";
    description = "Simple clipboard manager for Wayland";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ma27 ];
    platforms = lib.platforms.linux;
    mainProgram = "clipman";
  };
}
