{
  lib,
  pkgs,
  fetchFromGitHub,
  fetchurl,
  version ? "1.9.0",
  repoRev ? "v${version}",
  repoSrc ? fetchFromGitHub {
    owner = "mas-cli";
    repo = "mas";
    rev = repoRev;
    hash = "sha256-2Hvz1616cYItsgUK/FI0/s0f+GJ1qI2ZfEVLmw6iqdk=";
    name = "mas-${version}-source";
  },
  releaseSrc ? fetchurl {
    url = "https://github.com/mas-cli/mas/releases/download/${repoRev}/mas-${version}.pkg";
    hash = "sha256-MiSrCHLby3diTAzDPCYX1ZwdmzcHwOx/UJuWrlRJe54=";
    name = "mas-${version}.pkg";
  },
  enableSwiftDylibFix ? false,
  masBuildFromSource ? false,
}:
let
  self = rec {
    meta = with lib; {
      description = "Mac App Store command line interface";
      homepage = "https://github.com/mas-cli/mas";
      license = licenses.mit;
      maintainers = with maintainers; [
        # they seems inactive
        steinybot
        zachcoyle
      ];
      platforms = [
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      mainProgram = "mas";
    };

    # Apple provides swift dylib updates only via softwareupdate
    # if Apple drop supports for some old version macOS
    # one will need to get these dylib updates from other sources
    # or mas won't run

    # needs install_name_tool from stdenv
    # from swift on nixpkgs, read there for caveats
    fixSwiftDylib = swift: masRpathOrigin: ''
      declare -A systemLibs=(
      [libswiftCore.dylib]=1
      [libswiftDarwin.dylib]=1
      [libswiftSwiftOnoneSupport.dylib]=1
      # [libswift_Concurrency.dylib]=1 # using rpath
      )

      for systemLib in "''${!systemLibs[@]}"; do
      install_name_tool -change "/usr/lib/swift/$systemLib" "${swift.swift.lib}/${swift.swiftLibSubdir}/$systemLib" "$out/bin/mas"
      done
      install_name_tool -rpath "${masRpathOrigin}" "${swift.swift.lib}/${swift.swiftLibSubdir}" "$out/bin/mas"
    '';

    mas-from-src = pkgs.callPackage ./mas-from-src.nix {
      inherit mas-from-src;
      inherit
        version
        meta
        repoSrc
        enableSwiftDylibFix
        fixSwiftDylib
        ;
    };
    mas-from-release = pkgs.callPackage ./mas-from-release.nix {
      inherit mas-from-release releaseSrc;
      inherit
        version
        meta
        repoSrc
        enableSwiftDylibFix
        fixSwiftDylib
        ;
    };
  };
in
if masBuildFromSource then self.mas-from-src else self.mas-from-release
