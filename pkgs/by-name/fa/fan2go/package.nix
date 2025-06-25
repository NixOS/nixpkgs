{
  buildGoModule,
  fetchFromGitHub,
  lib,
  lm_sensors,
}:

buildGoModule rec {
  pname = "fan2go";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "markusressel";
    repo = "fan2go";
    tag = version;
    hash = "sha256-mLypuOGjYrXFf3BGCDggEDk1+PVx2CgsxAjZQ7uiSW0=";
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git rev-parse --short HEAD > $out/GIT_REV
      find $out -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-IJJTolpOtstVov8MNel6EOJqv1oCkTOTiPyW42ElQjc=";

  buildInputs = [ lm_sensors ];

  patches = [ ./lazy-binding.patch ];

  postConfigure = ''
    substituteInPlace vendor/github.com/md14454/gosensors/gosensors.go \
      --replace-fail '"/etc/sensors3.conf"' '"${lib.getLib lm_sensors}/etc/sensors3.conf"'

    # Uses /usr/bin/echo, and even if we patch that, it refuses to execute any
    # binary without being able to confirm that it's owned by root, which isn't
    # possible under the sandbox.
    rm internal/fans/cmd_test.go
  '';

  buildPhase = ''
    runHook preBuild

    make build GIT_REV="$(cat GIT_REV)"

    dir="$GOPATH/bin"
    mkdir -p "$dir"
    cp bin/fan2go "$dir"

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    make test
    runHook postCheck
  '';

  meta = with lib; {
    description = "Simple daemon providing dynamic fan speed control based on temperature sensors";
    mainProgram = "fan2go";
    homepage = "https://github.com/markusressel/fan2go";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ mtoohey ];
    platforms = platforms.linux;
  };
}
