{
  lib,
  stdenv,
  adaptivecpp,
  # Within the nix sandbox, and on the CI especially, the tests will likely be unable to access a gpu.
  # While the CI won't be able to test on a GPU, we can do a sanity check with OMP atleast
  #
  # The bulk of work in acpp focuses on the generic target, so we want to test that first and foremost.
  # Not setting an explicit target makes it default to the generic target.
  targets ? null,
  enablePstlTests ? false,
  onetbb,
  cmake,
  boost,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "${adaptivecpp.pname}-tests";
  inherit (adaptivecpp)
    version
    src
    ;

  nativeBuildInputs = [
    cmake
    onetbb
  ];
  buildInputs = [ boost ];

  sourceRoot = "${adaptivecpp.src.name}/tests";

  cmakeFlags = [
    (lib.cmakeFeature "AdaptiveCpp_DIR" "${adaptivecpp}/lib/cmake/AdaptiveCpp")
    (lib.cmakeBool "WITH_PSTL_TESTS" enablePstlTests)
  ]
  ++ lib.optionals (targets != null) [
    (lib.cmakeFeature "DACCP_TARGETS" "${targets}")
  ];

  installPhase = ''
    mkdir $out
    install -Dm755 sycl_tests -t $out/bin/
    install -Dm755 rt_tests -t $out/bin/
    install -Dm755 device_compilation_tests -t $out/bin/
    install -Dm755 dump_test/dump_test -t $out/bin/
    install -Dm755 platform_api/platform_api -t $out/bin/
  ''
  + lib.optionalString enablePstlTests ''
    install -Dm755 pstl_tests -t $out/bin/
  '';
})
