{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nls-cli";
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nolight132";
    repo = "nls";
    rev = "v${version}";
    hash = "sha256-kY/57F/k2Geei3WPC49HwDJl7B8frNiQugP04wHw50A=";
  };

  proxyVendor = true;
  vendorHash = "sha256-LgheQyb3W8wkqZT3fR9BWFHzh1U4I42AJktc292f6sc=";

  subPackages = [ "cmd/nls" ];

  meta = {
    description = "nls: a pretty ls alternative with Git status and directory sizes";
    homepage = "https://github.com/nolight132/nls";
    license = lib.licenses.mit;
    mainProgram = "nls";
    maintainers = [ lib.maintainers.Cesatorii ];
  };
}
