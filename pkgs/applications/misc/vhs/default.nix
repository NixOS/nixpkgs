{ lib, stdenv, buildGoModule, installShellFiles, fetchFromGitHub, ffmpeg, ttyd, chromium, makeWrapper }:

buildGoModule rec {
  pname = "vhs";
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-JKhijruaRjdMEbsIrcu2swSCb/nTxwIG/F9c2eGncnQ=";
  };

  vendorHash = "sha256-IpybcyW4up9QVV7fJCh+2Lrpi571tfravN17vh/G1bQ=";
=======
    hash = "sha256-qtewd4sm3urFwoDkqdUHfr2SvJRR1nVLLE5d28BocYg=";
  };

  vendorHash = "sha256-s1ISU7VEH9o7SBF3Vy+2kVZNxOFUYLmh/le5vU8rOqg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  postInstall = ''
    wrapProgram $out/bin/vhs --prefix PATH : ${lib.makeBinPath (lib.optionals stdenv.isLinux [ chromium ] ++ [ ffmpeg ttyd ])}
    $out/bin/vhs man > vhs.1
    installManPage vhs.1
    installShellCompletion --cmd vhs \
      --bash <($out/bin/vhs completion bash) \
      --fish <($out/bin/vhs completion fish) \
      --zsh <($out/bin/vhs completion zsh)
  '';

  meta = with lib; {
    description = "A tool for generating terminal GIFs with code";
    homepage = "https://github.com/charmbracelet/vhs";
    changelog = "https://github.com/charmbracelet/vhs/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ maaslalani penguwin ];
  };
}
