{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hanko";
  version = "0.9.0";

  src = "${fetchFromGitHub {
    owner = "teamhanko";
    repo = "hanko";
    rev = "backend/v${version}";
    hash = "sha256-TCbMejq1kVjju+yUtUen+TbqM1vbBa5XZyjqnZXTa1I=";
  }}/backend";

  vendorHash = "sha256-G9QehqeFAlKK3r+YsoEVj+o6yFo7FQ9O4JzcbJjUOM4=";

  ldflags = [
    "-s"
    "-w"
  ];

  # instead of the go generate script that uses git
  preBuild = ''
    echo ${version} > build_info/version.txt
  '';

  postInstall = ''
    mv $out/bin/backend $out/bin/hanko
  '';

  # requires socket connection
  doCheck = false;

  meta = with lib; {
    description = "Auth and user management for the passkey era";
    homepage = "https://github.com/teamhanko/hanko/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "hanko";
    platforms = platforms.all;
  };
}
