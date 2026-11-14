{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdvdcss";
  version = "1.5.0";

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;
  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = "libdvdcss";
    tag = finalAttrs.version;
    hash = "sha256-xQWfAfxqsaLZN0HMozsqY5mSIO9KvZ5RAb4bj/f6WWo=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru = {
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage.dev;
        versionCheck = true;
      };
    };
  };

  meta = {
    homepage = "http://www.videolan.org/developers/libdvdcss.html";
    changelog = "https://code.videolan.org/videolan/libdvdcss/blob/${finalAttrs.src.tag}/NEWS";
    description = "Library for decrypting DVDs";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    pkgConfigModules = [
      "libdvdcss"
    ];
  };
})
