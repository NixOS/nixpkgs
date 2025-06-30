{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  scdoc,
}:

buildGoModule rec {
  pname = "shfmt";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "sh";
    rev = "v${version}";
    hash = "sha256-PFUjJOVW7bCFOxi5/6D4dOu96T8jj1L5clMVLC/W1Fk=";
  };

  vendorHash = "sha256-2TSQYcKSzAHbqocQ5iboEUGM1DRis3J1TFlz0fOYQog=";

  subPackages = [ "cmd/shfmt" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  postBuild = ''
    scdoc < cmd/shfmt/shfmt.1.scd > shfmt.1
    installManPage shfmt.1
  '';

  meta = with lib; {
    homepage = "https://github.com/mvdan/sh";
    description = "Shell parser and formatter";
    longDescription = ''
      shfmt formats shell programs. It can use tabs or any number of spaces to indent.
      You can feed it standard input, any number of files or any number of directories to recurse into.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [
      zowoq
      SuperSandro2000
    ];
    mainProgram = "shfmt";
  };
}
