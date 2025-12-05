{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "honeymarker";
  version = "0.2.12";
  vendorHash = "sha256-jtDjy8Y2S5/Ujtv+dtoRZ4SP66sSP7yer97fwdNZEpg=";

  src = fetchFromGitHub {
    owner = "honeycombio";
    repo = "honeymarker";
    rev = "v${version}";
    hash = "sha256-28NCAtx3MHlwm44IUlI0DzUaycH9cPN8ZdEhhQtdciU=";
  };

  meta = with lib; {
    description = "Simple CRUD interface for dealing with per-dataset markers on honeycomb.io";
    homepage = "https://honeycomb.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.iand675 ];
  };
}
