{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  lksctp-tools,
  sctpSupport ? true,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cannelloni";
  version = "2.0.0";
  src = fetchFromGitHub {
    owner = "mguentner";
    repo = "cannelloni";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b3pBC2XFK+pyONvnkPw/0YUXAG2cRD1OaN7k2ONzFV8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = lib.optionals sctpSupport [ lksctp-tools ];

  cmakeFlags = [
    "-DSCTP_SUPPORT=${lib.boolToString sctpSupport}"
  ];

  nativeInstallInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SocketCAN over Ethernet tunnel";
    mainProgram = "cannelloni";
    homepage = "https://github.com/mguentner/cannelloni";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.samw ];
  };
})
