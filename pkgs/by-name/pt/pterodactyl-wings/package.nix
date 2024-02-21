{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  name = "pterodactyl-wings";
  version = "1.11.8";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "v${version}";
    hash = "sha256-JzbxROashDAL4NSeqMcWR9PgFqe9peBNpeofA347oE4=";
  };

  ldflags = [ "-s" "-w" "-X" "github.com/pterodactyl/wings/system.Version=${version}" ];
  vendorHash = "sha256-fn+U91jX/rmL/gdMwRAIDEj/m0Zqgy81BUyv4El7Qxw=";

  meta = with lib; {
    description = "The server control plane for Pterodactyl Panel. Written from the ground-up with security, speed, and stability in mind.";
    homepage    = "https://github.com/pterodactyl/wings";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ melvyn2 ];
  };
}
