{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "lf";
  version = "41";

  src = fetchFromGitHub {
    owner = "gokcehan";
    repo = "lf";
    tag = "r${finalAttrs.version}";
    hash = "sha256-s9d9nIOSpYeK6WNpbhauAEEv3SSBeJQ+J8ip+IE4LOc=";
  };

  vendorHash = "sha256-3i6Vp3rhE8R+TGLQE3axxKjVI/3nL+WSqEp7rHtSvNs=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.gVersion=r${finalAttrs.version}"
  ];

  # Force the use of the pure-go implementation of the os/user library.
  # Relevant issue: https://github.com/gokcehan/lf/issues/191
  tags = lib.optionals (!stdenv.hostPlatform.isDarwin) [ "osusergo" ];

  postInstall = ''
    install -D --mode=444 lf.desktop $out/share/applications/lf.desktop
    installManPage lf.1
    installShellCompletion etc/lf.{bash,zsh,fish}
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Terminal file manager written in Go and heavily inspired by ranger";
    longDescription = ''
      lf (as in "list files") is a terminal file manager written in Go. It is
      heavily inspired by ranger with some missing and extra features. Some of
      the missing features are deliberately omitted since it is better if they
      are handled by external tools.
    '';
    homepage = "https://godoc.org/github.com/gokcehan/lf";
    changelog = "https://github.com/gokcehan/lf/releases/tag/r${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    mainProgram = "lf";
  };
})
