{
  lib,
  fetchFromGitHub,
  rustPlatform,
  clang,
  pkg-config,
  elfutils,
  rustfmt,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "below";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "below";
    tag = "v${version}";
    hash = "sha256-tPweJFqhZMOL+M08bDjW6HPmtuhr9IXJNP0c938O7Cg=";
  };

  # Upstream forgot to commit an up-to-date lockfile.
  cargoPatches = [ ./update-Cargo.lock.patch ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-uNeWdsvJtkUz3E1NL10heDC7B55yKzDMMYzRhEE32EQ=";

  prePatch = ''
    sed -i "s,ExecStart=.*/bin,ExecStart=$out/bin," etc/below.service
  '';
  postInstall = ''
    install -d $out/lib/systemd/system
    install -t $out/lib/systemd/system etc/below.service
  '';

  # bpf code compilation
  hardeningDisable = [
    "stackprotector"
    "zerocallusedregs"
  ];

  nativeBuildInputs = [
    clang
    pkg-config
    rustfmt
  ];
  buildInputs = [
    elfutils
    zlib
  ];

  # needs /sys/fs/cgroup
  doCheck = false;

  meta = {
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ globin ];
    description = "Time traveling resource monitor for modern Linux systems";
    license = lib.licenses.asl20;
    homepage = "https://github.com/facebookincubator/below";
    mainProgram = "below";
  };
}
