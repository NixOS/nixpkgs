{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stuffbin";
  version = "1.1.0";

  vendorHash = null;

  src = fetchFromGitHub {
    owner = "knadh";
    repo = "stuffbin";
    rev = "v${version}";
    hash = "sha256-M72xNh7bKUMLzA+M8bJB++kJ5KCrkboQm1v8BasP3Yo=";
  };

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "Compress and embed static files and assets into Go binaries and access them with a virtual file system in production";
    homepage = "https://github.com/knadh/stuffbin";
    changelog = "https://github.com/knadh/stuffbin/releases/tag/v${version}";
    maintainers = with maintainers; [ raitobezarius ];
    license = licenses.mit;
  };
}
