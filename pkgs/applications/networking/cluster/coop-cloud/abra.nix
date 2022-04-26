{ buildGoModule, fetchFromGitea, lib, srcOnly }:

buildGoModule rec {
  pname = "abra";
  version = "0.4.1-alpha";
  src = fetchFromGitea {
    domain = "git.coopcloud.tech";
    owner = "coop-cloud";
    repo = "abra";
    rev = "${version}";
    sha256 = "sha256-HSAWnwxMsX09PdPy2AyQGprV1fRN+lG+a67L+xd3GlA=";
  };
  vendorSha256 = "sha256-2o7GPEStjdBEY2RMhApMTPjrC5H/B9c3s1B2t2pTh+A=";
  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];
  meta = with lib; {
    description = "The Co-op Cloud command-line utility belt 🎩🐇";
    homepage = "https://coopcloud.tech";
    downloadPage = "https://coopcloud.tech/abra";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ akshaymankar ];
  };
}
