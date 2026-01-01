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
  version = "16.1";

  src = fetchFromGitHub {
    owner = "rhboot";
    repo = "shim";
    tag = version;
    hash = "sha256-qHZfr7ncJOsb1Cijlp6eJSMzxa34H1h4lACqceOzg+s=";
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

<<<<<<< HEAD
  meta = {
    description = "UEFI shim loader";
    homepage = "https://github.com/rhboot/shim";
    license = lib.licenses.bsd1;
=======
  meta = with lib; {
    description = "UEFI shim loader";
    homepage = "https://github.com/rhboot/shim";
    license = licenses.bsd1;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
=======
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      baloo
      raitobezarius
    ];
  };
}
