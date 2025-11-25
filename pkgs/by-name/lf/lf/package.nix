{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "lf";
  version = "39";

  src = fetchFromGitHub {
    owner = "gokcehan";
    repo = "lf";
    tag = "r${version}";
    hash = "sha256-6M6xMVWHTLPlnG5i6/dC3KEV6RXezz8KK0V81P8RcE0=";
  };

  vendorHash = "sha256-93VPbrNPRW6NyKHJBvmAadbJ+DLsH2jTAXjTKkPdYBA=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.gVersion=r${version}"
  ];

  # Force the use of the pure-go implementation of the os/user library.
  # Relevant issue: https://github.com/gokcehan/lf/issues/191
  tags = lib.optionals (!stdenv.hostPlatform.isDarwin) [ "osusergo" ];

  postInstall = ''
    install -D --mode=444 lf.desktop $out/share/applications/lf.desktop
    installManPage lf.1
    installShellCompletion etc/lf.{bash,zsh,fish}
  '';

  meta = {
    description = "Terminal file manager written in Go and heavily inspired by ranger";
    longDescription = ''
      lf (as in "list files") is a terminal file manager written in Go. It is
      heavily inspired by ranger with some missing and extra features. Some of
      the missing features are deliberately omitted since it is better if they
      are handled by external tools.
    '';
    homepage = "https://godoc.org/github.com/gokcehan/lf";
    changelog = "https://github.com/gokcehan/lf/releases/tag/r${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    mainProgram = "lf";
  };
}
