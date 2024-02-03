{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "lxd-to-incus";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "incus";
    rev = "refs/tags/incus-${version}";
    hash = "sha256-WhprzGzTeB8sEMMTYN5j1Zrwg0GiGLlXTqCkcPq0XVo=";
  };

  patches = [
    ./d7f7ae55a54437616174f80fb8faa80ae4ffcda4.patch
  ];

  modRoot = "cmd/lxd-to-incus";

  vendorHash = "sha256-J95b4fm+VwndoxS8RQF8V8ufI3RjclqzAskEd3ut4bU=";

  CGO_ENABLED = 0;

  passthru = {
    updateScript = nix-update-script {
       extraArgs = [
        "-vr" "incus-\(.*\)"
       ];
     };
  };

  meta = {
    description = "LXD to Incus migration tool";
    homepage = "https://linuxcontainers.org/incus";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ adamcstephens ];
    platforms = lib.platforms.linux;
  };
}
