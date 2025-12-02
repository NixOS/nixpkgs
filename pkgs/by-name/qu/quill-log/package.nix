{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quill-log";
  version = "11.0.1";

  src = fetchFromGitHub {
    owner = "odygrd";
    repo = "quill";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h5vjHyhAVPcVZJFKbXFm2eUbesI088XkA7HZCCx9jzc=";
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
