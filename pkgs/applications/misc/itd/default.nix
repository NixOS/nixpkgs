{ stdenv
, lib
, buildGoModule
, fetchFromGitea
}:

buildGoModule rec {
  pname = "itd";
  version = "0.0.9";

  # https://gitea.arsenm.dev/Arsen6331/itd/tags
  src = fetchFromGitea {
    domain = "gitea.arsenm.dev";
    owner = "Arsen6331";
    repo = "itd";
    rev = "v${version}";
    hash = "sha256-FefffF8YIEcB+eglifNWuuK7H5A1YXyxxZOXz1a8HfY=";
  };

  vendorHash = "sha256-LFzrpKQQ4nFoK4vVTzJDQ5OGDe1y5BSfXPX+FRVunjQ=";

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

