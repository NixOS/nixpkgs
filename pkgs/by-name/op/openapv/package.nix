{
  lib,
  stdenv,
  writeText,
  fetchFromGitHub,
  cmake,
}:
let
  # Requires an /etc/os-release file, so we override it with this.
  osRelease = writeText "os-release" ''ID=NixOS'';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openapv";
  version = "0.2.0.1";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openapv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Edj3xQ7AcHcdIbg4o2FidAGZ06fUBltW+1ojJPoIktA=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/etc/os-release" "${osRelease}"
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    changelog = "https://github.com/AcademySoftwareFoundation/openapv/releases/tag/v${finalAttrs.version}";
    description = "Reference implementation of the APV codec";
    homepage = "https://github.com/AcademySoftwareFoundation/openapv";
    license = [ lib.licenses.bsd3 ];
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
