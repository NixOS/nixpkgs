{
  buildGoModule,
  fetchFromGitHub,
  lib,
  wl-clipboard,
  makeWrapper,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "clipman";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "clipman";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fAiXivLXpxezvMUKv0HfDvzSN60G4RFfgi6/fO0C1p8=";
  };

  vendorHash = "sha256-QD/ucnIqPHgKaYRmBO4fwDVqC7kKlYmBaZp3XBWudy0=";

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
})
