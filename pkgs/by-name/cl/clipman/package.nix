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
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "clipman";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-bee40nTmFMhWeP9vC7PTRQUZ/5OLZ4CtC5LlVBbfeNQ=";
  };

  vendorHash = "sha256-I31qF84k1r/xpROW9sZ5rs7lGAxwgqXUEQ9EEo8vsTY=";

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
