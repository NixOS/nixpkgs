{
  cmake,
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblsl";
  version = "1.17.5";

  src = fetchFromGitHub {
    owner = "sccn";
    repo = "liblsl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xu/Bdv+aA+XG/fPBNDPcHELem17vaV86e6F8zfVI//o=";
  };
  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;
  strictDeps = true;
  separateDebugInfo = true;
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DLSL_UNIXFOLDERS=ON" ];

  meta = {
    description = "C++ lsl library for multi-modal time-synched data transmission over the local network";
    homepage = "https://github.com/sccn/liblsl";
    changelog = "https://github.com/sccn/liblsl/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      abcsds
      pandapip1
    ];
    platforms = lib.platforms.all;
  };
})
