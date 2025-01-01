{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:

buildGoModule rec {
  pname = "pet";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "knqyf263";
    repo = "pet";
    rev = "v${version}";
    sha256 = "sha256-J6DrrCeuJrdVSBJNUcALiPOAP0SEjYYLSFEg7gEXvhs=";
  };

  vendorHash = "sha256-VGhkhpqYJZZLCUMOE0eYBOICeFhRjgSXCGGUEYLDoQo=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/knqyf263/pet/cmd.version=${version}"
  ];

  doCheck = false;

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd pet \
      --zsh ./misc/completions/zsh/_pet
  '';

  meta = with lib; {
    description = "Simple command-line snippet manager, written in Go";
    mainProgram = "pet";
    homepage = "https://github.com/knqyf263/pet";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
