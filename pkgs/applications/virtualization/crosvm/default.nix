{ stdenv, rustPlatform, fetchgit, runCommand, symlinkJoin
, pkgconfig, minijail, dtc, libusb1, libcap
}:

let

  upstreamInfo = with builtins; fromJSON (readFile ./upstream-info.json);

  arch = with stdenv.hostPlatform;
    if isAarch64 then "arm"
    else if isx86_64 then "x86_64"
    else throw "no seccomp policy files available for host platform";

  crosvmSrc = fetchgit {
    inherit (upstreamInfo.components."chromiumos/platform/crosvm")
      url rev sha256 fetchSubmodules;
  };

  adhdSrc = fetchgit {
    inherit (upstreamInfo.components."chromiumos/third_party/adhd")
      url rev sha256 fetchSubmodules;
  };

in

  rustPlatform.buildRustPackage rec {
    pname = "crosvm";
    inherit (upstreamInfo) version;

    unpackPhase = ''
      runHook preUnpack

      mkdir -p chromiumos/platform chromiumos/third_party

      pushd chromiumos/platform
      unpackFile ${crosvmSrc}
      mv ${crosvmSrc.name} crosvm
      popd

      pushd chromiumos/third_party
      unpackFile ${adhdSrc}
      mv ${adhdSrc.name} adhd
      popd

      chmod -R u+w -- "$sourceRoot"

      runHook postUnpack
    '';

    sourceRoot = "chromiumos/platform/crosvm";

    patches = [
      ./default-seccomp-policy-dir.diff
    ];

    cargoSha256 = "1s9nfgfqk140hg08i0xzylnrgrx84dqss0vnvhxnydwy9q03nk7r";

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

    passthru = {
      inherit adhdSrc;
      src = crosvmSrc;
      updateScript = ./update.py;
    };

    meta = with stdenv.lib; {
      description = "A secure virtual machine monitor for KVM";
      homepage = "https://chromium.googlesource.com/chromiumos/platform/crosvm/";
      maintainers = with maintainers; [ qyliss ];
      license = licenses.bsd3;
      platforms = [ "aarch64-linux" "x86_64-linux" ];
    };
  }
