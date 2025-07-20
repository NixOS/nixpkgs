{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "hishtory";
  version = "0.335";

  src = fetchFromGitHub {
    owner = "ddworken";
    repo = "hishtory";
    rev = "v${version}";
    hash = "sha256-nh3dNm+5h+3moeO1PUS6tPkftojMSSWSr0m/5n2iO2w=";
  };

  vendorHash = "sha256-tJjhHZT91vomGLM4IjMYBD4WfKo7eBcGu/osL6NTMwc=";

  ldflags = [ "-X github.com/ddworken/hishtory/client/lib.Version=${version}" ];

  subPackages = [ "." ];

  excludedPackages = [ "backend/server" ];

  postInstall = ''
    mkdir -p $out/share/hishtory
    cp client/lib/config.* $out/share/hishtory
  '';

  doCheck = true;

  meta = with lib; {
    description = "Your shell history: synced, queryable, and in context";
    homepage = "https://github.com/ddworken/hishtory";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "hishtory";
  };
}
