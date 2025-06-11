{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libX11,
  pam,
  stdenv,
}:

buildGoModule rec {
  pname = "emptty";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "tvrzna";
    repo = "emptty";
    rev = "v${version}";
    hash = "sha256-AsIt7EI5RkSchhaMGKofOsfPNROhX8f5gDaqZ7Q2394=";
  };

  buildInputs = [
    pam
    libX11
  ];

  vendorHash = "sha256-PLyemAUcCz9H7+nAxftki3G7rQoEeyPzY3YUEj2RFn4=";

  meta = with lib; {
    description = "Dead simple CLI Display Manager on TTY";
    homepage = "https://github.com/tvrzna/emptty";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
    # many undefined functions
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "emptty";
  };
}
