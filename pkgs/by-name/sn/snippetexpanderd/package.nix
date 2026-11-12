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

buildGoModule (finalAttrs: {
  pname = "snippetexpanderd";
  version = "1.1.2";

  src = fetchFromSourcehut {
    owner = "~ianmjones";
    repo = "snippetexpander";
    rev = "v${finalAttrs.version}";
    hash = "sha256-L+3Zn4z48ZqoVH38oxKg2BkhCTGynsIofQqMDzkfha4=";
  };

  vendorHash = "sha256-1ofkbbitCzrLxugi769jbjOD2iN0Z6kYC5d7X2GYNIg=";

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
    "-X 'main.version=${finalAttrs.src.rev}'"
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "snippetexpanderd";
  };
})
