{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  containerd,
}:

buildGoModule rec {
  pname = "nomad-driver-containerd";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "Roblox";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-11K1ACk2hhEi+sAlI932eKpyy82Md7j1edRWH2JJ8sI=";
  };

  # bump deps to fix CVE that isn't in a tagged release yet
  patches = [
    (fetchpatch {
      url = "https://github.com/Roblox/nomad-driver-containerd/commit/80b9be1353f701b9d47d874923a9e8ffed4dbd98.patch";
      hash = "sha256-d4C/YwemmZQAt0fTAnQkJVKn8cK4kmxB+wQEHycdn9U=";
    })
    (fetchpatch {
      url = "https://github.com/Roblox/nomad-driver-containerd/commit/cc0da224669a8f85a8b695288fe5ea748fb270c2.patch";
      hash = "sha256-W8ZOKMkv1814cPNyqTaXUGhh44WfMizZNL4cNX+FOqg=";
    })
  ];

  # replace version in file as it's defined using const, and thus cannot be overriden by ldflags
  postPatch = ''
    substituteInPlace containerd/driver.go --replace-warn 'PluginVersion = "v0.9.3"' 'PluginVersion = "v${version}"'
  '';

  CGO_ENABLED = "1";

  vendorHash = "sha256-OO+a5AqhB0tf6lyodhYl9HUSaWvtXWwevRHYy1Q6VoU=";
  subPackages = [ "." ];

  buildInputs = [ containerd ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://www.github.com/Roblox/nomad-driver-containerd";
    description = "Containerd task driver for Nomad";
    mainProgram = "nomad-driver-containerd";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
