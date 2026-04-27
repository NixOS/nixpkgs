{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule (finalAttrs: {
  pname = "prometheus-fail2ban-exporter";
  version = "0.10.3";

  src = fetchFromGitLab {
    owner = "hctrdev";
    repo = "fail2ban-prometheus-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CyYGY6SovnvgExB22G+LEKRDRzbDZWhWUjctJMkprYs=";
  };

  vendorHash = "sha256-ogdRXbS1EG402qlnj5SfuI/1P/Pi0+xwJrJsc6vwdds=";

  ldflags = [ "-s" ];

  meta = {
    description = "Collect and export metrics on Fail2Ban";
    homepage = "https://gitlab.com/hctrdev/fail2ban-prometheus-exporter";
    license = lib.licenses.mit;
    mainProgram = "fail2ban-prometheus-exporter";
    maintainers = with lib.maintainers; [
      bartoostveen
    ];
  };
})
