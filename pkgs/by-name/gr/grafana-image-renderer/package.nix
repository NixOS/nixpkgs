{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grafana-image-renderer";
<<<<<<< HEAD
  version = "5.1.0";
=======
  version = "5.0.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "grafana-image-renderer";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-Y6S2noQ5XdDSfPM6to0p1IDM5poBLQVeg/g3sgQjlM8=";
  };

  vendorHash = "sha256-kGLvstSkucM0tN5l+Vp78IP9EwDx62kukAiOwYD4Vfs=";

  postPatch = ''
    substituteInPlace go.mod --replace-fail 'go 1.25.5' 'go 1.25.4'
  '';

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/grafana/grafana-image-renderer";
    description = "Grafana backend plugin that handles rendering of panels & dashboards to PNGs using headless browser (Chromium/Chrome)";
    mainProgram = "grafana-image-renderer";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ma27 ];
=======
    hash = "sha256-oWJlb1mV1sNgN7EQ8L4msfnKps5oV60JgwZYpAJQaq4=";
  };

  vendorHash = "sha256-wA1XeLO2bYwq7HZOQ5UNcdqqJdEWRUxFoAQucXAj48k=";

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/grafana/grafana-image-renderer";
    description = "Grafana backend plugin that handles rendering of panels & dashboards to PNGs using headless browser (Chromium/Chrome)";
    mainProgram = "grafana-image-renderer";
    license = licenses.asl20;
    maintainers = with maintainers; [ ma27 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
