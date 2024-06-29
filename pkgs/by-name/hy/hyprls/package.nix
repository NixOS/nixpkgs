{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "hyprls";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "hyprls";
    rev = "v${version}";
    hash = "sha256-boA2kWlHm9bEM/o0xi/1FlH6WGU4wL1RRvbGGXdzHYQ=";
  };

  vendorHash = "sha256-rG+oGJOABA9ee5nIpC5/U0mMsPhwvVtQvJBlQWfxi5Y=";

  checkFlags = [
    # Not yet implemented
    "-skip=TestHighLevelParse"
  ];

  meta = with lib; {
    description = "A LSP server for Hyprland's configuration language";
    homepage = "https://en.ewen.works/hyprls";
    license = licenses.mit;
    maintainers = with maintainers; [ arthsmn ];
    platforms = platforms.all;
  };
}
