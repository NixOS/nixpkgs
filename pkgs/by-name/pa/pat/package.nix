{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libax25,
  installShellFiles,
}:

buildGoModule rec {
  pname = "pat";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "la5nta";
    repo = "pat";
    rev = "v${version}";
    hash = "sha256-2CQQKZ9ZnabMhvmbFeYBZ2iv9WJo6QR5IqROUXy7sck=";
  };

  vendorHash = "sha256-ajkRUnfYHCrFBxZsJLd6ypRl9+gYz+q4C/asOJZrVYg=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optional stdenv.hostPlatform.isLinux [ libax25 ];

  # Needed by wl2k-go go module for libax25 to include support for Linux' AX.25 stack by linking against libax25.
  # ref: https://github.com/la5nta/wl2k-go/blob/abe3ae5bf6a2eec670a21672d461d1c3e1d4c2f3/transport/ax25/ax25.go#L11-L17
  tags = lib.optionals stdenv.hostPlatform.isLinux [ "libax25" ];

  postInstall = ''
    installManPage man/pat-configure.1 man/pat.1
  '';

  meta = with lib; {
    description = "Cross-platform Winlink client written in Go";
    homepage = "https://getpat.io/";
    license = licenses.mit;
    maintainers = with maintainers; [
      dotemup
      sarcasticadmin
    ];
    platforms = platforms.unix;
    mainProgram = "pat";
  };
}
