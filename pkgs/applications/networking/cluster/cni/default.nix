{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "cni";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "containernetworking";
    repo = "cni";
    rev = "v${version}";
    hash = "sha256-xeajsM8ZIlI6Otv9CQhPfYaVQwmJ5QcFEn1xt6e/ivQ=";
  };

  vendorHash = "sha256-uo3ZwFdD6aJ0WDGmt51l3hs9agUnv1cIQY/KMlNe5nI=";

  subPackages = [
    "./cnitool"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Container Network Interface - networking for Linux containers";
    mainProgram = "cnitool";
    license = licenses.asl20;
    homepage = "https://github.com/containernetworking/cni";
    maintainers = with maintainers; [
      offline
      vdemeester
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
