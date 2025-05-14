{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "motion";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "fatih";
    repo = "motion";
    rev = "v${version}";
    sha256 = "sha256-7vkMhjO4JUAf0sUcKiMjqJ5GzLb//QoHd7Cagerx4/s=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Navigation and insight in Go";
    mainProgram = "motion";
    longDescription = ''
      Motion is a tool that was designed to work with editors. It is providing
      contextual information for a given offset(option) from a file or
      directory of files. Editors can use these informations to implement
      navigation, text editing, etc... that are specific to a Go source code.

      It's optimized and created to work with vim-go, but it's designed to work
      with any editor. It's currently work in progress and open to change.
    '';
    homepage = "https://github.com/fatih/motion";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
