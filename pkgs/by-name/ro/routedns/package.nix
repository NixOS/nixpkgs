{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "routedns";
  version = "0.1.131";

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "routedns";
    rev = "v${version}";
    hash = "sha256-KrRazsjNBsHWdkmJYeNmHDNAorAV5NuneumevChEuDQ=";
  };

  vendorHash = "sha256-woInU618JPwVxGDJDZQ6+j9wY6qNSB5Xu8wXf7s2qvQ=";

  subPackages = [ "./cmd/routedns" ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/folbricht/routedns";
    description = "DNS stub resolver, proxy and router";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jsimonetti ];
    mainProgram = "routedns";
  };
}
