{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, libax25
, installShellFiles
}:

buildGoModule rec {
  pname = "pat";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "la5nta";
    repo = "pat";
    rev = "v${version}";
    hash = "sha256-wNWqqGc4mf3z0ejMpU+jWhqCbjNJ2b6+pbBjDYKwKK8=";
  };

  vendorHash = "sha256-m5yb6+TfRApw0ZROx9ZA3RPiKV+1DHo/73CNQpIfMlU=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optional stdenv.isLinux [ libax25 ];

  # Needed by wl2k-go go module for libax25 to include support for Linux' AX.25 stack by linking against libax25.
  # ref: https://github.com/la5nta/wl2k-go/blob/abe3ae5bf6a2eec670a21672d461d1c3e1d4c2f3/transport/ax25/ax25.go#L11-L17
  tags = lib.optionals stdenv.isLinux [ "libax25" ];

  postInstall = ''
    installManPage man/pat-configure.1 man/pat.1
  '';

  meta = with lib; {
    description = "Pat is a cross platform Winlink client written in Go.";
    homepage = "https://getpat.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ dotemup sarcasticadmin ];
    platforms = platforms.unix;
  };
}
