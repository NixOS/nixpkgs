{ callPackage }:

let
  buildJX = callPackage ./jx.nix {};
  version = "3.2.169";
  rev = "v"+version;
in
  buildJX {
    pname = "jx-3";
    inherit version;
    sha256 = "09fa5z7id3b44pp7yc8qiyr45cpzzgqqsa1zdv8bxhmg38ygbv17";
    vendorSha256 = "06gm4kqldnm9w484d5c5563m3fdr9arry8jxprhy0x1jjsssbdc9";
    subPackages = [ "cmd" ];
    buildFlagsArray = [
      "-ldflags= -X github.com/jenkins-x/jx/pkg/cmd/version.Version=${version}
      -X github.com/jenkins-x/jx/pkg/cmd/version.Revision=${rev}
      -X github.com/jenkins-x/jx/pkg/cmd/version.GitTreeState=clean"
      ];
    postInstall = [ "mv $out/bin/cmd $out/bin/jx" ];
  }
