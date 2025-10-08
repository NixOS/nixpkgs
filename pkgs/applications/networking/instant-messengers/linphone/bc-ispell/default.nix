{
  cmake,
  fetchFromGitLab,
  lib,
  stdenv,

  # tests
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bc-ispell";
  # version retrieved from `CHANGES`
  version = "3.4.02-unstable-2025-05-05";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    group = "BC";
    owner = "public/external";
    repo = "ispell";
    rev = "05574fe160222c3d0b6283c1433c9b087271fad1";
    sha256 = "sha256-YoRLiMjk2BxoI27xc2nzucxfHV9UbouFRSECb3RdHGo=";
  };

  patches = [
    # linphone has custom find modules that look for this package,
    # but they do not work in nix, so we need to patch this library to
    # install regular cmake config files
    ./install-config-files.patch
  ];

  cmakeFlags = [
    "-DENABLE_STATIC=NO"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  nativeBuildInputs = [ cmake ];

  passthru.tests = {
    cmake-config = testers.hasCmakeConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [
        "ISpell"
      ];
    };
  };

  meta = {
    description = "Interactive spelling checker";
    homepage = "https://gitlab.linphone.org/BC/public/external/ispell";
    platforms = lib.platforms.all;
    # NOTE: ISpell itself does not explicitly provide a license. From its
    # 'Contributors' file, it can be deduced that it is distributed under
    # "some" open source license, but the details are not clear.
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [
      naxdy
    ];
  };
})
