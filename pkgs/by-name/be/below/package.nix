{
  lib,
  fetchFromGitHub,
  fetchpatch,
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

  cargoPatches = [
    (fetchpatch {
      name = "update-Cargo.lock.patch";
      url = "https://github.com/facebookincubator/below/commit/f46f9936ac29fa23f5cb02cafe93ae724649bafc.patch";
      hash = "sha256-J+M8FIuo8ToT3+9eZi5qfwfAW98XcNRqTIJd6O8z1Ig=";
    })
  ];

  cargoHash = "sha256-JrSSIwREHSg5YJivSdBIPjOkOtdw8qGCsa4yE7rJz/E=";

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
