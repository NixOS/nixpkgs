{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  libusb-compat-0_1,
  readline ? null,
  enableReadline ? true,
  hidapi ? null,
  pkg-config ? null,
  mspds ? null,
  enableMspds ? false,
}:

assert stdenv.hostPlatform.isDarwin -> hidapi != null && pkg-config != null;
assert enableReadline -> readline != null;
assert enableMspds -> mspds != null;

stdenv.mkDerivation rec {
  version = "0.26";
  pname = "mspdebug";
  src = fetchFromGitHub {
    owner = "dlbeer";
    repo = "mspdebug";
    rev = "v${version}";
    sha256 = "sha256-4TisC0Nm3lYMWCJ3TtaHDAfLDejMQZJIruh2f7fCndU=";
  };

  enableParallelBuilding = true;
  nativeBuildInputs =
    lib.optional stdenv.hostPlatform.isDarwin pkg-config
    ++ lib.optional (enableMspds && stdenv.hostPlatform.isLinux) autoPatchelfHook;
  buildInputs = [
    libusb-compat-0_1
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin hidapi
  ++ lib.optional enableReadline readline;

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # TODO: remove once a new 0.26+ release is made
    substituteInPlace drivers/tilib_api.c --replace .so ${stdenv.hostPlatform.extensions.sharedLibrary}

    # Makefile only uses pkg-config if it detects homebrew
    substituteInPlace Makefile --replace brew true
  '';

  # TODO: wrap with MSPDEBUG_TILIB_PATH env var instead of these rpath fixups in 0.26+
  runtimeDependencies = lib.optional enableMspds mspds;
  postFixup = lib.optionalString (enableMspds && stdenv.hostPlatform.isDarwin) ''
    # autoPatchelfHook only works on linux so...
    for dep in $runtimeDependencies; do
      install_name_tool -add_rpath $dep/lib $out/bin/$pname
    done
  '';

  installFlags = [
    "PREFIX=$(out)"
    "INSTALL=install"
  ];
  makeFlags = [ "UNAME_S=$(unameS)" ] ++ lib.optional (!enableReadline) "WITHOUT_READLINE=1";
  unameS = lib.optionalString stdenv.hostPlatform.isDarwin "Darwin";

  meta = {
    description = "Free programmer, debugger, and gdb proxy for MSP430 MCUs";
    mainProgram = "mspdebug";
    homepage = "https://dlbeer.co.nz/mspdebug/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aerialx ];
  };
}
