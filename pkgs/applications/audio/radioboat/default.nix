{ lib
, fetchFromGitHub
, buildGoModule
, mpv
, makeWrapper
, installShellFiles
, nix-update-script
, testers
, radioboat
}:

buildGoModule rec {
  pname = "radioboat";
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "slashformotion";
    repo = "radioboat";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-4k+WK2Cxu1yBWgvEW9LMD2RGfiY7XDAe0qqph82zvlI=";
  };

  vendorHash = "sha256-H2vo5gngXUcrem25tqz/1MhOgpNZcN+IcaQHZrGyjW8=";
=======
    sha256 = "sha256-nY8h09SDTQPKLAHgWr3q8yRGtw3bIWvAFVu05rqXPcg=";
  };

  vendorSha256 = "sha256-76Q77BXNe6NGxn6ocYuj58M4aPGCWTekKV5tOyxBv2U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X github.com/slashformotion/radioboat/internal/buildinfo.Version=${version}"
  ];

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  preFixup = ''
    wrapProgram $out/bin/radioboat --prefix PATH ":" "${lib.makeBinPath [ mpv ]}";
  '';

  postInstall = ''
    installShellCompletion --cmd radioboat \
      --bash <($out/bin/radioboat completion bash) \
      --fish <($out/bin/radioboat completion fish) \
      --zsh <($out/bin/radioboat completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = radioboat;
      command = "radioboat version";
<<<<<<< HEAD
=======
      version = version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  meta = with lib; {
    description = "A terminal web radio client";
    homepage = "https://github.com/slashformotion/radioboat";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
