{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "pachyderm";
  version = "1.8.5";
  rev = "v${version}";

  goPackagePath = "github.com/pachyderm/pachyderm";
  subPackages = [ "src/server/cmd/pachctl" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "pachyderm";
    repo = "pachyderm";
    sha256 = "1b9x2xn0sxsjid15lnwr79lps8xzf24i7jfl0i48nabdigmi04wp";
  };

  meta = with lib; {
    description = "Containerized Data Analytics";
    homepage = "https://github.com/pachyderm/pachyderm";
    license = licenses.asl20;
    maintainers = with maintainers; [offline];
    mainProgram = "pachctl";
  };
}
