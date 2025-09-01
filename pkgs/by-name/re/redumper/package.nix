{
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  llvmPackages,
}:

llvmPackages.libcxxStdenv.mkDerivation (finalAttrs: {
  pname = "redumper";
  version = "651";

  src = fetchFromGitHub {
    owner = "superg";
    repo = "redumper";
    tag = "build_${finalAttrs.version}";
    hash = "sha256-fnc4d1B7Ubu2IMHPDBXzrK0BWeCmPG/c03MEwxgKwxY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    llvmPackages.clang-tools
  ];

  # https://github.com/superg/redumper/blob/main/.github/workflows/cmake.yml
  cmakeFlags = [
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
    "-DREDUMPER_VERSION_BUILD=${finalAttrs.version}"
    "-DREDUMPER_CLANG_LINK_OPTIONS=" # overrides the '-static' default
  ];

  # Leads to: clang++: warning: argument unused during compilation: '-stdlib=libc++' [-Wunused-command-line-argument]
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-stdlib=libc++>)' ""
  '';

  meta = {
    homepage = "https://github.com/superg/redumper";
    description = "Low level CD dumper utility";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hughobrien ];
    platforms = lib.platforms.linux;
  };
})
