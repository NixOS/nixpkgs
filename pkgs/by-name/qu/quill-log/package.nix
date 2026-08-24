{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quill-log";
  version = "12.1.0";

  src = fetchFromGitHub {
    owner = "odygrd";
    repo = "quill";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1CL5twjO0uInbdjTF6VRMugoeBABiDjPGagf5HdW57E=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/odygrd/quill";
    changelog = "https://github.com/odygrd/quill/blob/master/CHANGELOG.md";
    downloadPage = "https://github.com/odygrd/quill";
    description = "Asynchronous Low Latency C++17 Logging Library";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.odygrd ];
  };
})
