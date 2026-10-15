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
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "clipman";
    rev = "v${finalAttrs.version}";
    hash = "sha256-K10ne2tov8/zq2xReZ4ypX8Tsz+5ijOP9dCbpMXFlGI=";
  };

  vendorHash = "sha256-H/a5n396U0+guxj/bTGf6R1LkPtGV0YnX7ETdC+pDTo=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.version=${finalAttrs.version}"
  ];

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
