{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  payload ? null,
}:

stdenv.mkDerivation {
  pname = "riscv-pk";
  version = "1.0.0-unstable-2025-09-19";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = "riscv-pk";
    rev = "9c61d29846d8521d9487a57739330f9682d5b542";
    sha256 = "sha256-jYva0aIom809y02WgEYEdeqMMjh5DcvoFVzF3nyHqkw=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  preConfigure = ''
    mkdir build
    cd build
  '';

  configureScript = "../configure";

  configureFlags = lib.optional (payload != null) "--with-payload=${payload}";

  hardeningDisable = [ "all" ];

  # pk installs into $out/$host_alias, which is empty on native builds
  installFlags = [ "INSTALLDIR=${placeholder "out"}" ];


  meta = {
    description = "RISC-V Proxy Kernel and Bootloader";
    homepage = "https://github.com/riscv-software-src/riscv-pk";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.riscv;
    maintainers = [ lib.maintainers.shlevy ];
  };
}
