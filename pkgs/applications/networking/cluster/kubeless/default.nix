{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeless";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "kubeless";
    repo = "kubeless";
    rev = "v${version}";
    sha256 = "1f5w6kn9rsaxx9nf6kzyjkzm3s9ycy1c8h78hb61v4x915xd3040";
  };
  modSha256 = "1pw4pwb8z2kq474jjipjdivlrin5zvw8d2if4317b0w0wyp6isgd";

  subPackages = [ "cmd/kubeless" ];

  buildFlagsArray = ''
    -ldflags=-X github.com/kubeless/kubeless/pkg/version.Version=${version}
  '';

  meta = with stdenv.lib; {
    homepage = "https://kubeless.io";
    description = "The Kubernetes Native Serverless Framework";
    license = licenses.asl20;
    maintainers = with maintainers; [ "00-matt" ];
    platforms = platforms.unix;
  };
}
