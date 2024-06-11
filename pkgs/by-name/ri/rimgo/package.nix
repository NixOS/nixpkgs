{
  lib,
  fetchFromGitea,
  buildGoModule,
  tailwindcss,
}:
buildGoModule rec {
  pname = "rimgo";
  version = "1.2.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "rimgo";
    repo = "rimgo";
    rev = "v${version}";
    hash = "sha256-nokXM+lnTiaWKwglmFYLBpnGHJn1yFok76tqb0nulVA=";
  };

  vendorHash = "sha256-wDTSqfp1Bb1Jb9XX3A3/p5VUcjr5utpe6l/3pXfZpsg=";

  nativeBuildInputs = [ tailwindcss ];

  preBuild = ''
    tailwindcss -i static/tailwind.css -o static/app.css -m
  '';

  ldflags = [
    "-s"
    "-w"
    "-X codeberg.org/rimgo/rimgo/pages.VersionInfo=${version}"
  ];

  meta = with lib; {
    description = "Alternative frontend for Imgur";
    homepage = "https://codeberg.org/rimgo/rimgo";
    license = licenses.agpl3Only;
    mainProgram = "rimgo";
    maintainers = with maintainers; [ quantenzitrone ];
  };
}
