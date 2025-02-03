{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libxcb,
  libXau,
  libXdmcp,
  darwin,
  lib
}:

stdenv.mkDerivation (finalAttrs: {
  name = "libclipboard";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "jtanx";
    repo = "libclipboard";
    rev = "v${finalAttrs.version}";
    hash = "sha256-553hNG8QUlt/Aff9EKYr6w279ELr+2MX7nh1SKIklhA=";
  };

  buildInputs = [ libxcb libXau libXdmcp ]
    ++ lib.optional stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ];
  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];
  outputs = [ "out" "dev" ];

  meta = {
    description = "Lightweight cross-platform clipboard library";
    homepage = "https://jtanx.github.io/libclipboard";
    changelog = "https://github.com/jtanx/libclipboard/releases/tag/${finalAttrs.src.rev}";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sigmanificient ];
  };
})
