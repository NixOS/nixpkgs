{ lib, buildGoModule, fetchFromGitHub, updateGolangSysHook }:

buildGoModule rec {
  pname = "ssh-chat";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "shazow";
    repo = "ssh-chat";
    rev = "v${version}";
    sha256 = "LgrqIuM/tLC0JqDai2TLu6G/edZ5Q7WFXjX5bzc0Bcc=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-T8/Y7JnMXI31QeNE2Y5jCuvdzclZ3pMOOSMph51MlbQ=";

  meta = with lib; {
    description = "Chat over SSH";
    homepage = "https://github.com/shazow/ssh-chat";
    license = licenses.mit;
    maintainers = with maintainers; [ luc65r ];
  };
}
