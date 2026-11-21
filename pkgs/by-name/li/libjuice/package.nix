{
  lib,
  stdenv,
  cmake,
  ninja,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libjuice";
  version = "1.7.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "paullouisageneau";
    repo = "libjuice";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nzvy5+v10nzFBudTDafGAmXn2Mpn2CN9dSgkLzCXJ3U=";
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
