{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "godef";
  version = "1.1.2";
  rev = "v${version}";

  subPackages = [ "." ];

  vendorHash = null;

  doCheck = false;

  src = fetchFromGitHub {
    inherit rev;
    owner = "rogpeppe";
    repo = "godef";
    sha256 = "0rhhg73kzai6qzhw31yxw3nhpsijn849qai2v9am955svmnckvf4";
  };

  meta = {
    description = "Print where symbols are defined in Go source code";
    mainProgram = "godef";
    homepage = "https://github.com/rogpeppe/godef/";
    maintainers = with lib.maintainers; [
      vdemeester
      rvolosatovs
    ];
    license = lib.licenses.bsd3;
  };
}
