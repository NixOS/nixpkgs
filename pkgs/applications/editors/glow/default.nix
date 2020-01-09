{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glow";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "glow";
    rev = "v${version}";
    sha256 = "0q35napi1aa6dfrqz26hvhzijymb9sxsf3mrrn1mh7ssgkhvmqqc";
  };

  modSha256 = "07imn9p0s79x1h45dk05hjcm6946d84j6k5pnljqrz4zk64hy26c";

  buildFlagsArray = [ "-ldflags=" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Render markdown on the CLI";
    homepage = "https://github.com/charmbracelet/glow";
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry filalex77 ];
  };
}
