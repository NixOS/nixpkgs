{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gosu,
}:

buildGoModule rec {
  pname = "gosu";
  version = "1.19";

  src = fetchFromGitHub {
    owner = "tianon";
    repo = "gosu";
    rev = version;
    hash = "sha256-Kl7roHOoKVPhWX4TWXP65brxV+bVBOAyphmWVpAQ15E=";
  };

  vendorHash = "sha256-/Q9h3uwnna9YDqNv8+2VOMaCbvsf9r7CvPrWwv5DvLE=";

  ldflags = [
    "-d"
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = gosu;
  };

  meta = with lib; {
    description = "Tool that avoids TTY and signal-forwarding behavior of sudo and su";
    mainProgram = "gosu";
    homepage = "https://github.com/tianon/gosu";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
