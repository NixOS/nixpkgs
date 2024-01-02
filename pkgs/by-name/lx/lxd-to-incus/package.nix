{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "lxd-to-incus";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "incus";
    rev = "refs/tags/v${version}";
    hash = "sha256-oPBrIN4XUc9GnBszEWAAnEcNahV4hfB48XSKvkpq5Kk=";
  };

  modRoot = "cmd/lxd-to-incus";

  vendorHash = "sha256-/ONflpW1HGvXooPF+Xui8q4xFu/Zq5br+Vjm9d2gm5U=";

  CGO_ENABLED = 0;

  passthru = {
    updateScript = nix-update-script {
       extraArgs = [
        "-vr" "v\(.*\)"
       ];
     };
  };

  meta = {
    description = "LXD to Incus migration tool";
    homepage = "https://linuxcontainers.org/incus";
    license = lib.licenses.asl20;
    maintainers = lib.teams.lxc.members;
    platforms = lib.platforms.linux;
  };
}
