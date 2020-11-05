{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "charm";
    rev = "v${version}";
    sha256 = "0wsh83kchqakvx7kgs2s31rzsvnfr47jk6pbmqzjv1kqmnlhc3rh";
  };

  vendorSha256 = "1lg4bbdzgnw50v6m6p7clibwm8m82kdr1jizgbmhfmzy15d5sfll";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Manage your charm account on the CLI";
    homepage = "https://github.com/charmbracelet/charm";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
