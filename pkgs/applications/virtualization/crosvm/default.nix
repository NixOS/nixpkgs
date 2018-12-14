{ stdenv, rustPlatform, fetchgit, runCommand, symlinkJoin
, pkgconfig, minijail, dtc, libusb1, libcap
}:

let

  upstreamInfo = with builtins; fromJSON (readFile ./upstream-info.json);

  arch = with stdenv.hostPlatform;
    if isAarch64 then "arm"
    else if isx86_64 then "x86_64"
    else throw "no seccomp policy files available for host platform";

  # used to turn symlinks into real files because write permissions are necessary for the vendoring process
  delink = src: runCommand "${src.name}-delinked" {
    preferLocalBuild = true;
    allowSubstitutes = false;
  } ''
    cp -prL --reflink=auto ${src} $out
  '';

  # used to place subtrees into the location they have in the Chromium monorepo
  move = src: target: runCommand "moved-${src.name}" {
    preferLocalBuild = true;
    allowSubstitutes = false;
  } ''
    mkdir -p $(dirname $out/${target})
    ln -s ${src} $out/${target}
  '';

  # used to check out subtrees from the Chromium monorepo
  chromiumSource = name: subtrees: delink (symlinkJoin {
    inherit name;
    paths = stdenv.lib.mapAttrsToList (
      location: { url, rev, sha256, fetchSubmodules, ... }:
      move (fetchgit {
        inherit url rev sha256 fetchSubmodules;
      }) location) subtrees;
  });

in

  rustPlatform.buildRustPackage rec {
    pname = "crosvm";
    inherit (upstreamInfo) version;

    src = chromiumSource "${pname}-sources" upstreamInfo.components;

    sourceRoot = "${src.name}/chromiumos/platform/crosvm";

    patches = [
      ./default-seccomp-policy-dir.patch
    ];

    cargoSha256 = "16cfp79c13ng5jjcrvz00h3cg7cc9ywhjiq02vsm757knn9jgr1v";

    nativeBuildInputs = [ pkgconfig ];

    buildInputs = [ dtc libcap libusb1 minijail ];

    postPatch = ''
      sed -i "s|/usr/share/policy/crosvm/|$out/share/policy/|g" \
             seccomp/*/*.policy
    '';

    preBuild = ''
      export DEFAULT_SECCOMP_POLICY_DIR=$out/share/policy
    '';

    postInstall = ''
      mkdir -p $out/share/policy/
      cp seccomp/${arch}/* $out/share/policy/
    '';

    passthru.updateScript = ./update.py;

    meta = with stdenv.lib; {
      description = "A secure virtual machine monitor for KVM";
      homepage = "https://chromium.googlesource.com/chromiumos/platform/crosvm/";
      license = licenses.bsd3;
      platforms = [ "aarch64-linux" "x86_64-linux" ];
    };
  }
