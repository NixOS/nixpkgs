{
  lib,
  stdenv,
  cmake,
  ninja,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libjuice";
  version = "1.7.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "paullouisageneau";
    repo = "libjuice";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XUcutgrP96hdXGUl4JjN2iovdkwYRw9LP6ze6S4Wp+A=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  meta = {
    description = "JUICE is a UDP Interactive Connectivity Establishment library";
    homepage = "https://github.com/paullouisageneau/libjuice";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      dvn0
    ];
  };
})
