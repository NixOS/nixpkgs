{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mtr-exporter";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mgumz";
    repo = "mtr-exporter";
    rev = version;
    hash = "sha256-dMlMUjbUg05Z8FFEPwMOiHzLiHSSjV1CzKqrt/qJ6Js=";
  };

  vendorHash = null;

  meta = {
    description = ''
      Mtr-exporter periodically executes mtr to a given host and
      provides the measured results as prometheus metrics.
    '';
    homepage = "https://github.com/mgumz/mtr-exporter";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jakubgs ];
    mainProgram = "mtr-exporter";
  };
}
