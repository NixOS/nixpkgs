{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libxi,
  libxrandr,
  libxt,
  libxtst,
}:

buildGoModule (finalAttrs: {
  pname = "remote-touchpad";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "unrud";
    repo = "remote-touchpad";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-uCrvVbpFPu7m+1jjYjQPy7iJ1zpqz5YuvO3gbHqBgOo=";
  };

  buildInputs = [
    libxi
    libxrandr
    libxt
    libxtst
  ];
  tags = [ "portal,x11" ];

  vendorHash = "sha256-M2VhhU5+iyqtMaN7Qt9SAdiEe77bdkW4sZELqwcXF5g=";

  meta = {
    description = "Control mouse and keyboard from the web browser of a smartphone";
    mainProgram = "remote-touchpad";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ schnusch ];
    platforms = lib.platforms.linux;
  };
})
