{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  version = "3.9.0pre";
  pname = "containerpilot";

  src = fetchFromGitHub {
    owner = "joyent";
    repo = pname;
    rev = "d999b632b0c96d9e27f092dc9f81a9d82dfe0106";
    sha256 = "0wsc8canr1c9wzr1lv40yixj9l10c66i6d14yrljsyagl2z02v4n";
  };

  goPackagePath = "github.com/joyent/${pname}";
  goDeps = ./deps.nix;

  meta = with lib; {
    homepage = "https://www.joyent.com/containerpilot";
    description = "An application centric micro-orchestrator.";
    mainProgram = "containerpilot";
    platforms = platforms.unix;
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}
