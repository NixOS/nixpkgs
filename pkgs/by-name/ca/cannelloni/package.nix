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
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "mguentner";
    repo = "cannelloni";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qvmb3w0yv5BQqS/taV7BbZxjvcmWlHsdnzk00a6G1ZU=";
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

  meta = with lib; {
    description = "SocketCAN over Ethernet tunnel";
    mainProgram = "cannelloni";
    homepage = "https://github.com/mguentner/cannelloni";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = [ maintainers.samw ];
  };
})
