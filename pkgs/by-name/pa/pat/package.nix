{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libax25,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "pat";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "la5nta";
    repo = "pat";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AYaHslPYNSl/s0d7gBxmC7IRvDGEezxzbABJSgRFuPg=";
  };

  vendorHash = "sha256-HkCXbJJFOlcp0Q9XcM1HC64EDWe/rn/nMpdpNOpgYFM=";

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

  meta = {
    description = "Cross-platform Winlink client written in Go";
    homepage = "https://getpat.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dotemup
      sarcasticadmin
    ];
    platforms = lib.platforms.unix;
    mainProgram = "pat";
  };
})
