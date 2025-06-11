{
  lib,
  fetchFromGitHub,
  cmake,
  llvmPackages_16,
  unstableGitUpdater,
}:

let
  c2ffiBranch = "llvm-16.0.0";
  llvmPackages = llvmPackages_16;
in

llvmPackages.stdenv.mkDerivation {
  pname = "c2ffi-${c2ffiBranch}";
  version = "0-unstable-2023-11-18";

  src = fetchFromGitHub {
    owner = "rpav";
    repo = "c2ffi";
    rev = "097cbe61ca02dc79ea60859aa056975131a9d985";
    hash = "sha256-pflolW5OoEkVDozy4cjCdUIVxgE/SfVKIhQyNBDhENc=";
  };

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/rpav/c2ffi.git";
    branch = c2ffiBranch;
    # Tags only exist for older LLVM versions, so they would result in nonsense names
    # like: c2ffi-llvm-16.0.0-11.0.0.0-unstable-YYYY-MM-DD
    hardcodeZeroVersion = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.clang
    llvmPackages.libclang
  ];

  # This isn't much, but...
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/c2ffi --help 2>&1 >/dev/null
  '';

  # LLVM may be compiled with -fno-rtti, so let's just turn it off.
  # A mismatch between lib{clang,LLVM}* and us can lead to the link time error:
  # undefined reference to `typeinfo for clang::ASTConsumer'
  env.CXXFLAGS = "-fno-rtti";

  meta = with lib; {
    homepage = "https://github.com/rpav/c2ffi";
    description = "LLVM based tool for extracting definitions from C, C++, and Objective C header files for use with foreign function call interfaces";
    mainProgram = "c2ffi";
    license = licenses.lgpl21Only;
    maintainers = [ ];
  };
}
