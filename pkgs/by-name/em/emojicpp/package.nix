{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gperf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "emojicpp";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "emmaexe";
    repo = "emojicpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2jFHRJvD/YQTFvjStGVm6ea/7+Tb3U9TF/JDlmFe0zY=";
  };

  nativeBuildInputs = [
    cmake
    gperf
  ];

  meta = {
    description = "A C++ library for parsing emoji names into emoji";
    homepage = "https://github.com/emmaexe/emojicpp";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ reivilibre ];
  };
})
