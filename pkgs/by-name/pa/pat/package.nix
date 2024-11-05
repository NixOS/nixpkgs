{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libax25,
  installShellFiles,
  fetchpatch,
}:

buildGoModule rec {
  pname = "pat";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "la5nta";
    repo = "pat";
    rev = "v${version}";
    hash = "sha256-JlqYdsAXs3pS5i59tiel+gxQsTrn5mUs0qLzjHxGZU0=";
  };

  # Remove upon next release since upstream is fixed
  # https://github.com/la5nta/pat/pull/449
  patches = [
    (fetchpatch {
      url = "https://github.com/la5nta/pat/commit/5604eac8853216d96d49d7d9947bdc514e195538.patch";
      sha256 = "sha256-Z9uoZLlhdCslULUxGkc4ao4ptC4ImWzSrfabSA5S/PE=";
    })
  ];

  vendorHash = "sha256-Z6p0wiOY5l++nch64BJWGXleBgUNecTDm+yVCnmXvtU=";

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
    description = "Pat is a cross platform Winlink client written in Go";
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
