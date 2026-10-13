{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mtr-exporter";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mgumz";
    repo = "mtr-exporter";
    rev = finalAttrs.version;
    hash = "sha256-X765/f6dnnu10dti22wXMr74MIGqOraTVVcOeQBAqeA=";
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
})
