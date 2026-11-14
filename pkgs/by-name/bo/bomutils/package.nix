{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bomutils";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "hogliux";
    repo = "bomutils";
    tag = finalAttrs.version;
    hash = "sha256-udVXbRvpl8Y364aKj48TxhxKLvr2E/Mcl3kxF/CC9sQ=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  # fix
  # src/lsbom.cpp:70:10: error: reference to 'data' is ambiguous
  # which refers to std::data from C++17
  env.NIX_CFLAGS_COMPILE = toString [ "-std=c++14" ];

  meta = {
    homepage = "https://github.com/hogliux/bomutils";
    description = "Open source tools to create bill-of-materials files used in macOS installers";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ prusnak ];
  };
})
