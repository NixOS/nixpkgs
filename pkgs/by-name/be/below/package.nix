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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "below";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "below";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Paf3+aVsJpC8wyNqszCp3y5qQS8LEAyXvJBp9VG4uFM=";
  };

  cargoHash = "sha256-8+8mBbQSFPcjfBB7y+dgyno+EW82ojhPNxx836gCMik=";

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
})
