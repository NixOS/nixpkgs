{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  payload ? null,
}:

stdenv.mkDerivation {
  pname = "riscv-pk";
  version = "1.0.0-unstable-2024-10-09";

  src = fetchFromGitHub {
    owner = "riscv";
    repo = "riscv-pk";
    rev = "abadfdc507d5a75b6272dc360e70a80a510c758a";
    sha256 = "sha256-02qcj0TAs7g4CSorWWbUzouS6mNthUOSdeocibw5g2A=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  preConfigure = ''
    mkdir build
    cd build
  '';

  configureScript = "../configure";

  configureFlags = lib.optional (payload != null) "--with-payload=${payload}";

  hardeningDisable = [ "all" ];

  # pk by default installs things in $out/$target_prefix/{bin,include,lib},
  # we want to remove the target prefix directory hierarchy
  postInstall = ''
    mv $out/* $out/.cleanup
    mv $out/.cleanup/* $out
    rmdir $out/.cleanup
  '';

  meta = {
    description = "RISC-V Proxy Kernel and Bootloader";
    homepage = "https://github.com/riscv/riscv-pk";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.riscv;
    maintainers = [ lib.maintainers.shlevy ];
  };
}
