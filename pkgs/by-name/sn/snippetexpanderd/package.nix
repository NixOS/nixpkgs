{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  makeWrapper,
  scdoc,
  installShellFiles,
  xclip,
  wl-clipboard,
  xdotool,
  wtype,
}:

buildGoModule rec {
  pname = "snippetexpanderd";
  version = "1.0.3";

  src = fetchFromSourcehut {
    owner = "~ianmjones";
    repo = "snippetexpander";
    rev = "v${version}";
    hash = "sha256-NIMuACrq8RodtjeBbBY42VJ8xqj7fZvdQ2w/5QsjjJI=";
  };

  vendorHash = "sha256-2nLO/b6XQC88VXE+SewhgKpkRtIHsva+fDudgKpvZiY=";

  proxyVendor = true;

  modRoot = "cmd/snippetexpanderd";

  nativeBuildInputs = [
    makeWrapper
    scdoc
    installShellFiles
  ];

  buildInputs = [
    xclip
    wl-clipboard
    xdotool
    wtype
  ];

  ldflags = [
    "-s"
    "-w"
    "-X 'main.version=${src.rev}'"
  ];

  postInstall = ''
    make man
    installManPage snippetexpanderd.1 snippetexpander-placeholders.5
  '';

  postFixup = ''
    # Ensure xclip/wcopy and xdotool/wtype are available for copy and paste duties.
    wrapProgram $out/bin/snippetexpanderd \
      --prefix PATH : ${
        lib.makeBinPath [
          xclip
          wl-clipboard
          xdotool
          wtype
        ]
      }
  '';

  meta = {
    description = "Your little expandable text snippet helper daemon";
    homepage = "https://snippetexpander.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
    mainProgram = "snippetexpanderd";
  };
}
