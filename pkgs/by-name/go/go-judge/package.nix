{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "go-judge";
  version = "1.8.9";

  src = fetchFromGitHub {
    owner = "criyle";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mYbE3QTnWrdfoqtI+RjXI+Vt7EjM7eHYBkTHfjURL6o=";
  };

  vendorHash = "sha256-47h/qN2vWTTrzoE7sEywYq8uGbyR04agbjiA+aEoQIQ=";

  tags = [ "nomsgpack" ];

  subPackages = [ "cmd/go-judge" ];

  preBuild = ''
    echo v${version} > ./cmd/go-judge/version/version.txt
  '';

  env.CGO_ENABLED = 0;

  meta = with lib; {
    description = "High performance sandbox service based on container technologies";
    homepage = "https://github.com/criyle/go-judge";
    license = licenses.mit;
    mainProgram = "go-judge";
    maintainers = with maintainers; [ criyle ];
  };
}
