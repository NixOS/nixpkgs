{
  buildGoModule,
  fetchFromGitHub,
  lib,
  pam,
  stdenv,
  util-linux,
  x11Support ? true,
  xauth,
  xorg-server,
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
  ];

  vendorHash = "sha256-PLyemAUcCz9H7+nAxftki3G7rQoEeyPzY3YUEj2RFn4=";

  postPatch = lib.optionalString x11Support ''
    substituteInPlace src/session_xorg.go \
      --replace-fail '/usr/bin/mcookie' '${lib.getExe' util-linux "mcookie"}' \
      --replace-fail '/usr/bin/xauth' '${lib.getExe xauth}' \
      --replace-fail '/usr/bin/Xorg' '${lib.getExe' xorg-server "Xorg"}'
  '';

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
