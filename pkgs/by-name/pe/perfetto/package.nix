{
  lib,
  stdenv,
  fetchgit,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "perfetto";
  version = "47.0";

  src = fetchgit {
    url = "https://android.googlesource.com/platform/external/perfetto";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-bKcgWK3Wf5ku1oOZ5iduSTsHyu3Nzegle3yDUpURsLQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];
})
