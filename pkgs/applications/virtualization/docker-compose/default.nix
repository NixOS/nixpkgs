{
  buildGoModule
, fetchFromGitHub
, lib
}:
buildGoModule rec {
  pname = "docker-compose";
  version = "2.6.0";
  src = fetchFromGitHub {
    owner = "docker";
    repo = "compose";
    rev = "v${version}";
    sha256 = "sha256-Fg99ugaqH/jL3KUZ5Vh/SJnqzEyOaR/KuPFwt2oqXxM=";
  };
  ldflags = [
    "-X github.com/docker/compose/v2/internal.Version=${version}"
  ];

  postFixup = ''
    mv $out/bin/{cmd,docker-compose}
    rm $out/bin/main
  '';
  doCheck = false; # requires docker
  vendorSha256 = "sha256-7uNQNO+EI90J2Btz2tnumKqd+AtVWON+Csh6tkTNKNA=";
  meta = with lib; {
    description = "Multi-container orchestration for Docker";
    homepage = "https://docs.docker.com/compose/";
    license = licenses.asl20;
    maintainers = with maintainers; [ Frostman ];
  };
}
