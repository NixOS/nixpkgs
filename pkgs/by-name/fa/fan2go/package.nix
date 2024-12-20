{
  buildGo123Module,
  fetchFromGitHub,
  lib,
  lm_sensors,
}:

buildGo123Module rec {
  pname = "fan2go";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "markusressel";
    repo = pname;
    rev = version;
    hash = "sha256-eSHeHBzDvzsDAck0zexwR8drasisvlQNTeowv92E2uc=";
  };

  vendorHash = "sha256-ad0e/cxbcU/KfPDOdD46KdCcvns83dgGDAyLLQiGyiA=";

  postConfigure = ''
    substituteInPlace vendor/github.com/md14454/gosensors/gosensors.go \
      --replace-fail '"/etc/sensors3.conf"' '"${lm_sensors}/etc/sensors3.conf"'

    # Uses /usr/bin/echo, and even if we patch that, it refuses to execute any
    # binary without being able to confirm that it's owned by root, which isn't
    # possible under the sandbox.
    rm internal/fans/cmd_test.go
  '';

  CGO_CFLAGS = "-I ${lm_sensors}/include";
  CGO_LDFLAGS = "-L ${lm_sensors}/lib";

  meta = with lib; {
    description = "Simple daemon providing dynamic fan speed control based on temperature sensors";
    mainProgram = "fan2go";
    homepage = "https://github.com/markusressel/fan2go";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ mtoohey ];
    platforms = platforms.linux;
  };
}
