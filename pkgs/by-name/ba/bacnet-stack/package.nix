{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bacnet-stack";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "bacnet-stack";
    repo = "bacnet-stack";
    tag = "bacnet-stack-${finalAttrs.version}";
    hash = "sha256-CJmEEIGT6u2nsnl3btWL/JJPxQM53JF6l+mLBSF+Q8Q=";
  };

  nativeBuildInputs = [ cmake ];

  # bacnet-stack's CMakeLists builds the apps via add_executable() but never
  # adds install(TARGETS ...) rules for them, so `make install` skips them.
  # Copy them out of the CMake build tree manually.
  postInstall = ''
    mkdir -p $out/bin
    find . -maxdepth 2 -type f -executable -not -name '*.so*' -not -name '*.a' \
      -exec cp -t $out/bin {} +
  '';

  meta = {
    description = "BACnet open source protocol stack for embedded systems, Linux, and Windows";
    homepage = "https://github.com/bacnet-stack/bacnet-stack";
    changelog = "https://github.com/bacnet-stack/bacnet-stack/blob/bacnet-stack-${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl2Plus # Core stack (WITH GCC-exception-2.0)
      mit # Examples and applications
      asl20 # Auxiliary files (SPDX identified)
      bsd3 # Auxiliary files (SPDX identified)
    ];
    maintainers = with lib.maintainers; [ WhittlesJr ];
    platforms = lib.platforms.linux;
  };
})
