{ stdenv, lib, rustPlatform, fetchgit
, minijail-tools, pkg-config, wayland-scanner
, libcap, libdrm, libepoxy, minijail, virglrenderer, wayland, wayland-protocols
}:

let
  upstreamInfo = with builtins; fromJSON (readFile ./upstream-info.json);
in

rustPlatform.buildRustPackage rec {
  pname = "crosvm";
  inherit (upstreamInfo) version;

  src = fetchgit (builtins.removeAttrs upstreamInfo.src [ "date" "path" ]);

  separateDebugInfo = true;

  patches = [
    ./default-seccomp-policy-dir.diff
  ];

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [ minijail-tools pkg-config wayland-scanner ];

  buildInputs = [
    libcap libdrm libepoxy minijail virglrenderer wayland wayland-protocols
  ];

  arch = stdenv.hostPlatform.parsed.cpu.name;

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
    sed -i "s|/usr/share/policy/crosvm/|$PWD/seccomp/$arch/|g" \
        seccomp/$arch/*.policy
  '';

  preBuild = ''
    export DEFAULT_SECCOMP_POLICY_DIR=$out/share/policy

    for policy in seccomp/$arch/*.policy; do
        compile_seccomp_policy \
            --default-action trap $policy ''${policy%.policy}.bpf
    done
  '';

  buildFeatures = [ "default" "virgl_renderer" "virgl_renderer_next" ];

  postInstall = ''
    mkdir -p $out/share/policy/
    cp -v seccomp/$arch/*.bpf $out/share/policy/
  '';

  passthru.updateScript = ./update.py;

  meta = with lib; {
    description = "A secure virtual machine monitor for KVM";
    homepage = "https://chromium.googlesource.com/crosvm/crosvm/";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.bsd3;
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
