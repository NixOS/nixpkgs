{ lib, buildGoModule, fetchFromGitHub, installShellFiles, callPackage }:

buildGoModule rec {
  pname = "micro";
<<<<<<< HEAD
  version = "2.0.12";
=======
  version = "2.0.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-L8yJE3rjNcx+1gawQ8urZcFfoQdO20E67mJQjWaVwVo=";
  };

  vendorHash = "sha256-h00s+xqepj+odKAgf54s35xMnnj3gtx5LWDOYFx5GY0=";

=======
    sha256 = "sha256-3Rppi8UcAc4zdXOd81Y+sb5Psezx2TQsNw73WdPVMgE=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/micro" ];

<<<<<<< HEAD
=======
  vendorSha256 = "sha256-/bWIn5joZOTOtuAbljOc0NgBfjrFkbFZih+cPNHnS9w=";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ldflags = let t = "github.com/zyedidia/micro/v2/internal"; in [
    "-s"
    "-w"
    "-X ${t}/util.Version=${version}"
    "-X ${t}/util.CommitHash=${src.rev}"
  ];

  preBuild = ''
    go generate ./runtime
  '';

  postInstall = ''
    installManPage assets/packaging/micro.1
    install -Dt $out/share/applications assets/packaging/micro.desktop
    install -Dm644 assets/micro-logo-mark.svg $out/share/icons/hicolor/scalable/apps/micro.svg
  '';

<<<<<<< HEAD
  passthru.tests.expect = callPackage ./test-with-expect.nix { };
=======
  passthru.tests.expect = callPackage ./test-with-expect.nix {};
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://micro-editor.github.io";
    description = "Modern and intuitive terminal-based text editor";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
<<<<<<< HEAD
    mainProgram = "micro";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
