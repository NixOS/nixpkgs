{
  lib,
  fetchFromGitea,
  buildGoModule,
  tailwindcss,
}:
buildGoModule rec {
  pname = "rimgo";
  version = "1.2.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "rimgo";
    repo = "rimgo";
    rev = "v${version}";
    hash = "sha256-C878ABs978viVtIuv3fPn2F2anOg2GB/+f5jaCO13tc=";
  };

  vendorHash = "sha256-u5N7aI9RIQ3EmiyHv0qhMcKkvmpp+5G7xbzdQcbhybs=";

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
    description = "An alternative frontend for Imgur";
    homepage = "https://codeberg.org/rimgo/rimgo";
    license = licenses.agpl3Only;
    mainProgram = "rimgo";
    maintainers = with maintainers; [ quantenzitrone ];
  };
}
