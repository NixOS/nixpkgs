{ buildGoModule, fetchFromGitHub, lib }:
with lib;
{ pname, version, sha256, vendorSha256, subPackages ? [], buildFlagsArray ? [], postInstall ? [], nativeBuildInputs ? [] } @args:

    buildGoModule rec {
      inherit pname;
      inherit version;

      src = fetchFromGitHub {
        owner = "jenkins-x";
        repo = "jx";
        rev = "v${version}";
        inherit sha256;
      };

      inherit vendorSha256;

      runVend = true;

      doCheck = false;

      inherit subPackages;

      inherit nativeBuildInputs;

      inherit buildFlagsArray;

      inherit postInstall;

      meta = with lib; {
        description = "Command line tool for installing and using Jenkins X";
        homepage = "https://jenkins-x.io";
        longDescription = ''
          Jenkins X provides automated CI+CD for Kubernetes with Preview
          Environments on Pull Requests using Jenkins, Knative Build, Prow,
          Skaffold and Helm.
        '';
        license = licenses.asl20 ;
        maintainers = with maintainers; [ kalbasit ];
        platforms = platforms.linux ++ platforms.darwin;
      };
    }
