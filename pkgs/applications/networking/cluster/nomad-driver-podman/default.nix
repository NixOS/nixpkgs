{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nomad-driver-podman";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-L2OnnSTrr49THE2ZQpuHagTjcg3/pt/ydivGmWZSvas=";
  };

  vendorHash = "sha256-0a8wnwyquDrEnPlR337uCxMzuc/9MjgGUsDd+xIfPhw=";

  subPackages = [ "." ];

  # some tests require a running podman service
  doCheck = false;

  meta = with lib; {
    homepage = "https://www.github.com/hashicorp/nomad-driver-podman";
    description = "Podman task driver for Nomad";
    mainProgram = "nomad-driver-podman";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}
