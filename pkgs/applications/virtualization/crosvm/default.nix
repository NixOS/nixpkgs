{ stdenv, lib, rustPlatform, fetchgit
, minijail-tools, pkg-config, protobuf, wayland-scanner
, libcap, libdrm, libepoxy, minijail, virglrenderer, wayland, wayland-protocols
}:

let
  src = fetchgit {
    url = "https://chromium.googlesource.com/crosvm/crosvm";
    rev = "265aab613b1eb31598ea0826f04810d9f010a2c6";
    sha256 = "OzbtPHs6BWK83RZ/6eCQHA61X6SY8FoBkaN70a37pvc=";
    fetchSubmodules = true;
  };

  # use vendored virglrenderer
  virglrenderer' = virglrenderer.overrideAttrs (oa: {
    src = "${src}/third_party/virglrenderer";
  });
in

rustPlatform.buildRustPackage rec {
  pname = "crosvm";
  version = "104.0";

  inherit src;

  separateDebugInfo = true;

  patches = [
    ./default-seccomp-policy-dir.diff
  ];

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [ minijail-tools pkg-config protobuf wayland-scanner ];

  buildInputs = [
    libcap libdrm libepoxy minijail virglrenderer' wayland wayland-protocols
  ];

  arch = stdenv.hostPlatform.parsed.cpu.name;

  postPatch = ''
    cp ${cargoLock.lockFile} Cargo.lock
    sed -i "s|/usr/share/policy/crosvm/|$PWD/seccomp/$arch/|g" \
        seccomp/$arch/*.policy
  '';

  preBuild = ''
    export DEFAULT_SECCOMP_POLICY_DIR=$out/share/policy

    for policy in seccomp/$arch/*.policy; do
        compile_seccomp_policy \
            --default-action trap $policy ''${policy%.policy}.bpf
    done

    substituteInPlace seccomp/$arch/*.policy \
      --replace "@include $(pwd)/seccomp/$arch/" "@include $out/share/policy/"
  '';

  buildFeatures = [ "default" "virgl_renderer" "virgl_renderer_next" ];

  postInstall = ''
    mkdir -p $out/share/policy/
    cp -v seccomp/$arch/*.{policy,bpf} $out/share/policy/
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
