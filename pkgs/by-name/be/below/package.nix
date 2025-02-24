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
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "below";
    rev = "v${version}";
    sha256 = "sha256-87Fdx3Jqi3dNWM5DZl+UYs031qn2DoiiWd3IysT/glQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iRDe3zg7tfEYGLCRY6bJ6OdoT8ej0MB/vteCIf5xqNA=";

  prePatch = ''sed -i "s,ExecStart=.*/bin,ExecStart=$out/bin," etc/below.service'';
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

  meta = with lib; {
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ];
    description = "Time traveling resource monitor for modern Linux systems";
    license = licenses.asl20;
    homepage = "https://github.com/facebookincubator/below";
    mainProgram = "below";
  };
}
