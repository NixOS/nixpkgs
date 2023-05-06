{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nova";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = pname;
    rev = version;
    hash = "sha256-l2HBjM5DyeWkdAwQGzPp+A3UuXXc0OTizInsVL0k/0I=";
  };

  vendorHash = "sha256-YvYfSb2ZC86S2osFRG7Ep9nrgYJV0tB8fBgZQZ07t2U=";

  ldflags = [ "-X main.version=${version}" "-s" "-w" ];

  meta = with lib; {
    description = "Find outdated or deprecated Helm charts running in your cluster";
    longDescription = ''
      Nova scans your cluster for installed Helm charts, then
      cross-checks them against all known Helm repositories. If it
      finds an updated version of the chart you're using, or notices
      your current version is deprecated, it will let you know.
    '';
    homepage = "https://nova.docs.fairwinds.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
