{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
<<<<<<< HEAD
  versionCheckHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildGoModule rec {
  pname = "lf";
<<<<<<< HEAD
  version = "40";
=======
  version = "38";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "gokcehan";
    repo = "lf";
    tag = "r${version}";
<<<<<<< HEAD
    hash = "sha256-NPbv64ezcuGn6n6qQOCBLeofS08uX9ZWpSXTVpmQr+A=";
  };

  vendorHash = "sha256-ybcwACun2GrANW47Nny60l8M+L9TZHzD95+qxVJKHpA=";
=======
    hash = "sha256-a3Ql0E3ZVbveGXGO+n2G2WBVjBk5HuJx9NiaZ7ZAVMc=";
  };

  vendorHash = "sha256-kZFmCkYd6ijJC/vedUoWZW1TUW1oGD9qA0GCQzfiTUE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
