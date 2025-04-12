{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nsq";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "nsqio";
    repo = "nsq";
    rev = "v${version}";
    hash = "sha256-qoAp8yAc4lJmlnHHcZskRzkleZ3Q5Gu3Lhk9u1jMR4g=";
  };

  vendorHash = "sha256-/5nH7zHg8zxWFgtVzSnfp7RZGvPWiuGSEyhx9fE2Pvo=";

  excludedPackages = [ "bench" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://nsq.io/";
    description = "Realtime distributed messaging platform";
    changelog = "https://github.com/nsqio/nsq/raw/v${version}/ChangeLog.md";
    license = licenses.mit;
  };
}
