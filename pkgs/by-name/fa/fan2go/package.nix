{
  config,
  buildGoModule,
  fetchFromGitHub,
  lib,
  lm_sensors,
  autoAddDriverRunpath,
  enableNVML ? config.cudaSupport,
}:

buildGoModule (finalAttrs: {
  pname = "fan2go";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "markusressel";
    repo = "fan2go";
    tag = finalAttrs.version;
    hash = "sha256-JU6hk3JJwoiC3R+Qx6QKzALnvhTA0/luQzO5X6Cpb/I=";
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git rev-parse --short HEAD > $out/GIT_REV
      find $out -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-6rcU7Qtzz80WcygeLVftdpGYAuzGmWD0M+ZVxgGcgnI=";

  nativeBuildInputs = lib.optionals enableNVML [
    autoAddDriverRunpath
  ];

  buildInputs = [ lm_sensors ];

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

    make build${lib.optionalString (!enableNVML) "-no-nvml"} GIT_REV="$(cat GIT_REV)"

    dir="$GOPATH/bin"
    mkdir -p "$dir"
    cp bin/fan2go "$dir"

    runHook postBuild
  '';

  postFixup = lib.optionalString enableNVML ''
    patchelf --add-needed libnvidia-ml.so "$out/bin/fan2go"
  '';

  checkPhase = ''
    runHook preCheck
    make test
    runHook postCheck
  '';

  meta = {
    description = "Simple daemon providing dynamic fan speed control based on temperature sensors";
    mainProgram = "fan2go";
    homepage = "https://github.com/markusressel/fan2go";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ mtoohey ];
    platforms = lib.platforms.linux;
  };
})
