{
  lib,
  stdenv,
  writeText,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:
let
  # Requires an /etc/os-release file, so we override it with this.
  osRelease = writeText "os-release" "ID=NixOS";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openapv";
  version = "0.2.1.3-fix";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openapv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lc/x2dWh6T8c63siHB32ka+SPVYTTyaO4YrQ12EbGqw=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/etc/os-release" "${osRelease}"
  '';

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/AcademySoftwareFoundation/openapv/releases/tag/v${finalAttrs.version}";
    description = "Reference implementation of the APV codec";
    homepage = "https://github.com/AcademySoftwareFoundation/openapv";
    license = [ lib.licenses.bsd3 ];
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
