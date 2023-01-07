{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.85.1";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-WfV7n4AgZoD8rOd6UVBFRqOz9qs1frjSGLUhjxqTG08=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-EkB8GjWtOO3Yi0PFFE8G8swwzYmw6D6LDO24vnSrkLs=";

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
