{ stdenv
, lib
, buildGoModule
, fetchFromGitea
}:

buildGoModule rec {
  pname = "itd";
  version = "1.1.0";

  # https://gitea.arsenm.dev/Arsen6331/itd/tags
  src = fetchFromGitea {
    domain = "gitea.arsenm.dev";
    owner = "Arsen6331";
    repo = "itd";
    rev = "v${version}";
    hash = "sha256-95/9Qy0HhrX+ORuv6g1T4/Eq1hf539lYG5fTkLeY6B0=";
  };

  vendorHash = "sha256-ZkAxNs4yDUFBhhmIRtzxQlEQtsa/BTuHy0g3taFcrMM=";

  preBuild = ''
    echo r${version} > version.txt
  '';

  subPackages = [
    "."
    "cmd/itctl"
  ];

  postInstall = ''
    install -Dm644 itd.toml $out/etc/itd.toml
  '';

  meta = with lib; {
    description = "itd is a daemon to interact with the PineTime running InfiniTime";
    homepage = "https://gitea.arsenm.dev/Arsen6331/itd";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mindavi raphaelr ];
  };
}

