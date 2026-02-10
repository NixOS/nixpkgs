{
  cmake,
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblsl";
  version = "1.16.2";

  src = fetchFromGitHub {
    owner = "sccn";
    repo = "liblsl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-nmu7Kxk4U5sGO8Od9JR4id4V4mjeibj4AHjUYhpGPeo=";
  };
  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DLSL_UNIXFOLDERS=ON" ];

  meta = {
    description = "C++ lsl library for multi-modal time-synched data transmission over the local network";
    homepage = "https://github.com/sccn/liblsl";
    changelog = "https://github.com/sccn/liblsl/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ abcsds ];
    platforms = lib.platforms.all;
  };
})
