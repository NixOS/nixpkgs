{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "scrutiny";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = "scrutiny";
    rev = "v${version}";
    hash = "sha256-UYKi+WTsasUaE6irzMAHr66k7wXyec8FXc8AWjEk0qs=";
  };

  vendorHash = "sha256-SiQw6pq0Fyy8Ia39S/Vgp9Mlfog2drtVn43g+GXiQuI=";

  ldflags = [ "-s" "-w" ];

  # TOFIX tests failing
  doCheck = false;

  postPatch = ''
    substituteInPlace example.{collector,scrutiny}.yaml \
      webapp/backend/{pkg/config/config.go,cmd/scrutiny/scrutiny.go} \
      --replace '/opt' '/var/lib'
  '';

  postInstall = ''
    install -Dm444 example.{collector,scrutiny}.yaml -t $out/share/doc/scrutiny
  '';

  meta = {
    description = "Hard Drive S.M.A.R.T Monitoring, Historical Trends & Real World Failure Thresholds";
    homepage = "https://github.com/AnalogJ/scrutiny";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eclairevoyant ];
    mainProgram = "scrutiny";
  };
}
