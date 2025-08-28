{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "filesystem";
  version = "1.5.14";

  src = fetchFromGitHub {
    owner = "gulrak";
    repo = "filesystem";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XZ0IxyNIAs2tegktOGQevkLPbWHam/AOFT+M6wAWPFg=";
  };

  nativeBuildInputs = [ cmake ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Header-only single-file C++ std::filesystem compatible helper library";
    homepage = "https://github.com/gulrak/filesystem";
    changelog = "https://github.com/gulrak/filesystem/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bbjubjub
      getchoo
    ];
  };
})
