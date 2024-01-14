{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubectl-klock";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "applejag";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fR97rTMFwtqVH9wqKy1+EzKKg753c18v8VDCQ2Y69+s=";
  };

  vendorHash = "sha256-AkYKKM4PR/msG44MwdSq6XAf6EvdtJHoXyw7Xj7MXso=";

  meta = with lib; {
    description = "A kubectl plugin to render watch output in a more readable fashion";
    homepage = "https://github.com/applejag/kubectl-klock";
    changelog = "https://github.com/applejag/kubectl-klock/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.scm2342 ];
  };
}
