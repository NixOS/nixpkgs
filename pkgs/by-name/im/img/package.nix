{
  buildGoModule,
  fetchFromGitHub,
  lib,
  makeWrapper,
  runc,
  wrapperDir ? "/run/wrappers/bin", # Default for NixOS, other systems might need customization.
}:

buildGoModule rec {
  pname = "img";
  version = "0.5.11";

  src = fetchFromGitHub {
    owner = "genuinetools";
    repo = "img";
    rev = "v${version}";
    sha256 = "0r5hihzp2679ki9hr3p0f085rafy2hc8kpkdhnd4m5k4iibqib08";
  };

  vendorHash = null;

  postPatch = ''
    V={newgidmap,newgidmap} \
      substituteInPlace ./internal/unshare/unshare.c \
        --replace "/usr/bin/$V" "${wrapperDir}/$V"
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  tags = [
    "seccomp"
    "noembed" # disables embedded `runc`
  ];

  ldflags = [
    "-X github.com/genuinetools/img/version.VERSION=v${version}"
    "-s -w"
  ];

  postInstall = ''
    wrapProgram "$out/bin/img" --prefix PATH : ${lib.makeBinPath [ runc ]}
  '';

  # Tests fail as: internal/binutils/install.go:57:15: undefined: Asset
  doCheck = false;

  meta = with lib; {
    description = "Standalone, daemon-less, unprivileged Dockerfile and OCI compatible container image builder";
    mainProgram = "img";
    license = licenses.mit;
    homepage = "https://github.com/genuinetools/img";
    maintainers = with maintainers; [ bryanasdev000 ];
  };
}
