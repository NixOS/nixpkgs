{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "linkerd-unstablle";
  version = "2019-07-26";

  src = fetchFromGitHub {
    owner = "linkerd";
    repo = "linkerd2";
    rev = "065dd3ec9d4b84c90383b31be16ccadd34a8ab0d";
    sha256 = "01m8g627sd126as0a74fy9svmymwd41sifd897nhn6kz78a21gq8";
  };

  modSha256 = "0gahhywpcj16ww4l8s3wjwvavq24fpy258snhyf94ipy6lb797sl";

  subPackages = [ "cli/cmd" ];

  meta = with stdenv.lib; {
    description = "A service mesh for Kubernetes and beyond.";
    homepage = https://linkerd.io/;
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih ];
  };
}
