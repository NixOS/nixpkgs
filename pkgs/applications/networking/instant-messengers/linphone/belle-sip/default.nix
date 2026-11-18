{
  bctoolbox,
  belr,
  lib,
  libantlr3c,
  stdenv,
  zlib,
  python3,
  mkLinphoneDerivation,
  httplib,
}:
mkLinphoneDerivation {
  pname = "belle-sip";

  nativeBuildInputs = [
    python3
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-Wno-error=cast-function-type"
      "-Wno-error=deprecated-declarations"
      "-Wno-error=format-truncation"
      "-Wno-error=stringop-overflow"
    ]
    ++ lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "12") [
      # Needed with GCC 12 but problematic with some old GCCs and probably clang
      "-Wno-error=use-after-free"
    ]
  );

  # Upstream uses a vendored fork of `cpp-httplib`, which we don't,
  # so to allow downstream dependencies to find ours, we need to ensure
  # they actually look for it.
  postPatch = ''
    substituteInPlace cmake/BelleSIPConfig.cmake.in \
      --replace-fail \
        'include("''${CMAKE_CURRENT_LIST_DIR}/BelleSIPTargets.cmake")' \
        'include(CMakeFindDependencyMacro)
        if(@ENABLE_UNIT_TESTS@)
        find_dependency(httplib)
        endif()
        include("''${CMAKE_CURRENT_LIST_DIR}/BelleSIPTargets.cmake")'
  '';

  preConfigure = ''
    rm -rf ./tester/cpp-httplib
    ln -s ${httplib.src} ./tester/cpp-httplib
  '';

  buildInputs = [ httplib ];

  propagatedBuildInputs = [
    libantlr3c
    bctoolbox
    belr
    zlib
  ];

  meta = {
    description = "Modern library implementing SIP (RFC 3261) transport, transaction and dialog layers. Part of the Linphone project";
    mainProgram = "belle_sip_tester";
    license = lib.licenses.gpl3Only;
  };
}
