{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "qbec";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "qbec";
    rev = "v${version}";
    sha256 = "0j0ybbv4ix864scmghy1lvr3rs2fbj49cva6x48kbwli4y447758";
  };

  modSha256 = "165zqmannlylkzaz9gkmcrlyx8rfhz70ahzhiks4ycgq1qxr0av9";

  meta = with lib; {
    description = "Configure kubernetes objects on multiple clusters using jsonnet https://qbec.io";
    homepage = "https://github.com/splunk/qbec";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
