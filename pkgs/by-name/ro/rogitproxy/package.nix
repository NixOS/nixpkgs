{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  openssh,
}:

buildGoModule {
  pname = "rogitproxy";
  version = "0-unstable-2026-07-28";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "rogitproxy";
    rev = "4d969f5df8ebe3d101221cb3116c689552a8f469";
    hash = "sha256-S1SPw0mm1PcL2CTcOXoHbWnSYlCr3vrW+R7odktS6BU=";
  };

  vendorHash = "sha256-V4yY+40Rv/vlCIVALHFHRgJKZBXk7Whl/J5qINfBhaE=";

  nativeBuildInputs = [
    git
    openssh
  ];

  preCheck = ''
    export GIT_AUTHOR_NAME="Test"
    export GIT_AUTHOR_EMAIL="test@test"
    export GIT_COMMITTER_NAME="Test"
    export GIT_COMMITTER_EMAIL="test@test"
  '';

  meta = {
    description = "Read-only Git protocol proxy for a Tailscale tailnet";
    homepage = "https://github.com/tailscale/rogitproxy";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.squat ];
    mainProgram = "rogitproxy";
  };
}
