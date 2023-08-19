{ version, lib, stdenv, pkgsOn, testers, cloudflared, runCommand, wine, wine64 }:

let
  inherit (stdenv) buildPlatform;
in
{
  version = testers.testVersion {
    package = cloudflared;
    command = "cloudflared help";
  };
  refuses-to-autoupdate = runCommand "cloudflared-${version}-refuses-to-autoupdate"
    {
      nativeBuildInputs = [ cloudflared ];
    } ''
    set -e
    cloudflared update 2>&1 | tee output.txt
    if ! grep "cloudflared was installed by nixpkgs" output.txt
    then
      echo "cloudflared's output didn't contain the package manager name"
      exit 1
    fi
    mkdir $out
  '';
} // lib.optionalAttrs (buildPlatform.isLinux && (buildPlatform.isi686 || buildPlatform.isx86_64)) {
  runs-through-wine = runCommand "cloudflared-${version}-runs-through-wine"
    {
      nativeBuildInputs = [ wine ];
      exe = "${pkgsOn.i686.w64.windows.gnu.cloudflared}/bin/cloudflared.exe";
    } ''
    export HOME="$(mktemp -d)"
    wine $exe help
    mkdir $out
  '';
} // lib.optionalAttrs (buildPlatform.isLinux && buildPlatform.isx86_64) {
  runs-through-wine64 = runCommand "cloudflared-${version}-runs-through-wine64"
    {
      nativeBuildInputs = [ wine64 ];
      exe = "${pkgsOn.x86_64.w64.windows.gnu.cloudflared}/bin/cloudflared.exe";
    } ''
    export HOME="$(mktemp -d)"
    wine64 $exe help
    mkdir $out
  '';
}
