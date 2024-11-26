{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pyemvue,
}:

buildHomeAssistantComponent rec {
  owner = "presto8";
  domain = "emporia_vue";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "magico13";
    repo = "ha-emporia-vue";
    rev = "v${version}";
    hash = "sha256-6NrRuBjpulT66pVUfW9ujULL5HSzfgyic1pKEBRupNA=";
  };

  propagatedBuildInputs = [
    pyemvue
  ];

  postPatch = ''
    substituteInPlace custom_components/emporia_vue/manifest.json --replace-fail 'pyemvue==0.17.1' 'pyemvue>=0.17.1'
  '';

  dontBuild = true;

  meta = with lib; {
    description = "Reads data from the Emporia Vue energy monitor into Home Assistant";
    homepage = "https://github.com/magico13/ha-emporia-vue";
    changelog = "https://github.com/magico13/ha-emporia-vue/releases/tag/v${version}";
    maintainers = with maintainers; [ presto8 ];
    license = licenses.mit;
  };
}
