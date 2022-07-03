{ stdenv, lib, rustPlatform, fetchgit
, pkg-config, wayland-scanner, libcap, minijail, wayland, wayland-protocols
, linux
}:

let

  upstreamInfo = with builtins; fromJSON (readFile ./upstream-info.json);

  arch = with stdenv.hostPlatform;
    if isAarch64 then "arm"
    else if isx86_64 then "x86_64"
    else throw "no seccomp policy files available for host platform";

in

  rustPlatform.buildRustPackage rec {
    pname = "crosvm";
    inherit (upstreamInfo) version;

    src = fetchgit (builtins.removeAttrs upstreamInfo.src [ "date" "path" ]);

    patches = [
      ./default-seccomp-policy-dir.diff
    ];

    cargoLock.lockFile = ./Cargo.lock;

    nativeBuildInputs = [ pkg-config wayland-scanner ];

    buildInputs = [ libcap minijail wayland wayland-protocols ];

    postPatch = ''
      cp ${./Cargo.lock} Cargo.lock
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

    CROSVM_CARGO_TEST_KERNEL_BINARY =
      lib.optionalString (stdenv.buildPlatform == stdenv.hostPlatform)
        "${linux}/${stdenv.hostPlatform.linux-kernel.target}";

    passthru.updateScript = ./update.py;

    meta = with lib; {
      description = "A secure virtual machine monitor for KVM";
      homepage = "https://chromium.googlesource.com/chromiumos/platform/crosvm/";
      maintainers = with maintainers; [ qyliss ];
      license = licenses.bsd3;
      platforms = [ "aarch64-linux" "x86_64-linux" ];
    };
  }
