{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libx11,
  pam,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "emptty";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "tvrzna";
    repo = "emptty";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EwXGaTwdL2jOLk+DR35mffhkPa1UVvfZ1Gx1KefbeGc=";
  };

  buildInputs = [
    pam
    libx11
  ];

  vendorHash = "sha256-PLyemAUcCz9H7+nAxftki3G7rQoEeyPzY3YUEj2RFn4=";

  meta = {
    description = "Dead simple CLI Display Manager on TTY";
    homepage = "https://github.com/tvrzna/emptty";
    license = lib.licenses.mit;
    maintainers = [ ];
    # many undefined functions
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "emptty";
  };
})
