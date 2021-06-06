{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-doctor";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "emirozer";
    repo = pname;
    rev = version;
    sha256 = "0x784jbcwd34vzdnhg2yldh5ivkxvs2qlbsvaammbxkn04ch1ijz";
  };

  vendorSha256 = "04xq5kp1m7c98gb4fd0dni258vpfnhv535gl2qllfcp2mvk3mn55";

  postInstall = ''
    mv $out/bin/{cmd,kubectl-doctor}
  '';

  meta = with lib; {
    description = "kubectl cluster triage plugin for k8s";
    homepage = "https://github.com/emirozer/kubectl-doctor";
    changelog = "https://github.com/emirozer/kubectl-doctor/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.zimbatm ];
  };
}
