{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-landlock";
  version = "0-unstable-2024-02-16";

  src = fetchFromGitHub {
    owner = "landlock-lsm";
    repo = "go-landlock";
    rev = "efb66220540a9ef86aa0160d15e55f429d5b94d9";
    hash = "sha256-U0+364NIw3kVcfS8/RTcpSMrv4v2ATCcC1v+5IsxeXQ=";
  };

  vendorHash = "sha256-IOaFToz/66Z1DP5O6gLqTyEiiYyrwZ5At93qPLa7hg8=";

  subPackages = [
    "cmd/landlock-restrict-net"
    "cmd/landlock-restrict"
  ];

  meta = {
    description = "Go library for the Linux Landlock sandboxing feature";
    homepage = "https://github.com/landlock-lsm/go-landlock";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomfitzhenry ];
  };
}
