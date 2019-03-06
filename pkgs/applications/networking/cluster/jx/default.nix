{ buildGoPackage, fetchFromGitHub, lib }:

let
  removeVendoredPackages = goDeps:
    ''
      echo "Removing any vendored duplicate of direct dependency... "
      for dir in $(find $NIX_BUILD_TOP/go/src -type d -name vendor); do
        ${builtins.concatStringsSep "\n" (map (goDep: ''
          if test -d $dir/${goDep.goPackagePath}; then
            echo "Removing duplicate directory at $dir/${goDep.goPackagePath}"
            rm -rf $dir/${goDep.goPackagePath}
          fi
        '') goDeps)}
      done
      echo "Done"
    '';
in
buildGoPackage rec {
  name = "jx";
  version = "1.3.955";

  goPackagePath = "github.com/jenkins-x/jx";
  subPackages = [ "cmd/jx" ];

  src = fetchFromGitHub {
    owner = "jenkins-x";
    repo = "jx";
    rev = "v${version}";
    sha256 = "0h4ck1a8rlyg10gaxbnwvlabwjlhdrigrina84x4m2gsqr3lnp9a";
  };

  # Some of the dependencies have their own checked in vendor directory that
  # vendor their dependencies. However, some of those dependencies are also
  # directly pulled down through the vgo modules. Removing these dependencies
  # as they confuse the go compiler and causes the build to fail.
  # Removing all the vendor directories also breaks the build.
  preBuild = removeVendoredPackages (import goDeps);

  buildFlagsArray = ''
    -ldflags=
    -X ${goPackagePath}/pkg/version.Version=${version}
    -X ${goPackagePath}/pkg/version.Revision=${version}
  '';

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "JX is a command line tool for installing and using Jenkins X.";
    longDescription = ''
      Jenkins X provides automated CI+CD for Kubernetes with Preview
      Environments on Pull Requests using Jenkins, Knative Build, Prow,
      Skaffold and Helm.
    '';
    homepage = https://github.com/jenkins-x/jx;
    license = licenses.asl20 ;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
