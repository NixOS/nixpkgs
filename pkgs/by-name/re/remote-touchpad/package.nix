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
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "unrud";
    repo = "remote-touchpad";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Erflr02yv6RT6vF9/WKMO7h0lEr2NMPinK7bj/SPMvI=";
  };

  buildInputs = [
    libxi
    libxrandr
    libxt
    libxtst
  ];
  tags = [ "portal,x11" ];

  vendorHash = "sha256-9e8mfGpR7HtpB+Fca69pKQH52FZciOnpsD/bi1JW4q0=";

  meta = {
    description = "Control mouse and keyboard from the web browser of a smartphone";
    mainProgram = "remote-touchpad";
    homepage = "https://github.com/unrud/remote-touchpad";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ schnusch ];
    platforms = lib.platforms.linux;
  };
})
