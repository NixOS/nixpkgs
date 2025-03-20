{
  lib,
  fetchFromGitea,
  buildGoModule,
  tailwindcss_3,
}:
buildGoModule rec {
  pname = "rimgo";
  version = "1.2.6";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "rimgo";
    repo = "rimgo";
    rev = "v${version}";
    hash = "sha256-PBzbCiRIDrtKH3j6jxmylPpwafR5qgRYDHgYP1m/+Ok=";
  };

  vendorHash = "sha256-nk1Pl9K62RjmBUgTlbp3u6cCoiEwpUHavfT3Oy0iyGU=";

  nativeBuildInputs = [ tailwindcss_3 ];

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
