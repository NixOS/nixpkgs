{ lib
, fetchFromGitHub
, buildGo121Module
}:
buildGo121Module rec {
  pname = "athens";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "gomods";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-m75Ut1UVwz7uWneBwPxUL7aPOXIpy6YPqIXMwczHOpY=";
  };

  vendorHash = "sha256-zK4EE242Gbgew33oxAUNxylKdhRdPhqP0Hrpu4sYiFg=";

  CGO_ENABLED = "0";
  ldflags = [ "-s" "-w" "-buildid=" "-X github.com/gomods/athens/pkg/build.version=${version}" ];
  flags = [ "-trimpath" ];

  subPackages = [ "cmd/proxy" ];

  postInstall = ''
    mv $out/bin/proxy $out/bin/athens
  '';

  meta = with lib; {
    description = "A Go module datastore and proxy";
    homepage = "https://github.com/gomods/athens";
    changelog = "https://github.com/gomods/athens/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "athens";
    maintainers = with maintainers; [ katexochen malt3 ];
    platforms = platforms.unix;
  };
}
