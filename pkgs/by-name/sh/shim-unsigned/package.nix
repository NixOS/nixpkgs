{
  stdenv,
  fetchFromGitHub,
  lib,
  elfutils,
  vendorCertFile ? null,
  defaultLoader ? null,
}:

let

  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  archSuffix =
    {
      x86_64-linux = "x64";
      aarch64-linux = "aa64";
    }
    .${system} or throwSystem;
in
stdenv.mkDerivation rec {
  pname = "shim";
  version = "16.0";

  src = fetchFromGitHub {
    owner = "rhboot";
    repo = "shim";
    rev = version;
    hash = "sha256-KFpt//A4/T0FRBSPuTKQH/mEIqLVEiE+Lpvuq7ec6eo=";
    fetchSubmodules = true;
  };

  buildInputs = [ elfutils ];

  env.NIX_CFLAGS_COMPILE = toString [ "-I${toString elfutils.dev}/include" ];

  makeFlags =
    lib.optional (vendorCertFile != null) "VENDOR_CERT_FILE=${vendorCertFile}"
    ++ lib.optional (defaultLoader != null) "DEFAULT_LOADER=${defaultLoader}";

  installTargets = [ "install-as-data" ];
  installFlags = [
    "DATATARGETDIR=$(out)/share/shim"
  ];

  passthru = {
    # Expose the arch suffix and target file names so that consumers
    # (e.g. infrastructure for signing this shim) don't need to
    # duplicate the logic from here
    inherit archSuffix;
    target = "shim${archSuffix}.efi";
    mokManagerTarget = "mm${archSuffix}.efi";
    fallbackTarget = "fb${archSuffix}.efi";
  };

  meta = with lib; {
    description = "UEFI shim loader";
    homepage = "https://github.com/rhboot/shim";
    license = licenses.bsd1;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [
      baloo
      raitobezarius
    ];
  };
}
