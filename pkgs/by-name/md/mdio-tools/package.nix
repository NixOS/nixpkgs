{
  autoreconfHook,
  fetchFromGitHub,
  lib,
  libmnl,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mdio-tools";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "wkz";
    repo = "mdio-tools";
    tag = finalAttrs.version;
    hash = "sha256-NomChJrYwMDPXNw5r2p11kGfYUvJBHCdLXy1SA8kOaM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ libmnl ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail "git describe --always --dirty --tags" "echo ${finalAttrs.version}"
  '';

  meta = {
    description = "Low-level debug tools for MDIO devices";
    homepage = "https://github.com/wkz/mdio-tools";
    changelog = "https://github.com/wkz/mdio-tools/blob/${finalAttrs.src.rev}/ChangeLog.md";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "mdio";
    platforms = lib.platforms.linux;
  };
})
