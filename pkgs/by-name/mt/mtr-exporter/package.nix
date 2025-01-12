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

  meta = with lib; {
    description = ''
      Mtr-exporter periodically executes mtr to a given host and
      provides the measured results as prometheus metrics.
    '';
    homepage = "https://github.com/mgumz/mtr-exporter";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jakubgs ];
    mainProgram = "mtr-exporter";
  };
}
