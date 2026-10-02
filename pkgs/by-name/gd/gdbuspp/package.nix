{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  glib,
  pkg-config,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gdbuspp";
  version = "3";
  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "gdbuspp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LwEUNBQ7BUyoTm8tBgE4hwL7AbimCY/grQus8lWSI/M=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/OpenVPN/gdbuspp/commit/7462325fb03d318658eaa9fecfc34f46cc5705fc
      url = "https://github.com/OpenVPN/gdbuspp/commit/7462325fb03d318658eaa9fecfc34f46cc5705fc.patch";
      hash = "sha256-pg1iWCbyGas7B/11Kt2ke/TlH1LC1EgNlUv7okuE5Sc=";
    })
  ];

  # The upstream patch's proxy.cpp hunk has context from post-v3 refactors.
  patchFlags = [
    "-p1"
    "--fuzz=2"
  ];

  postPatch = ''
    patchShebangs --build ./scripts/get-git-ref
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [ glib ];

  # fix build for gcc 15
  env.NIX_CFLAGS_COMPILE = "-Wno-error=free-nonheap-object";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GDBus++ - a glib2 D-Bus wrapper for C++";
    longDescription = ''
      This library provides a simpler C++ based interface to implement D-Bus
      into applications in a more C++ approach, based on the C++17 standard.
    '';
    homepage = "https://codeberg.org/OpenVPN/gdbuspp";
    changelog = "https://codeberg.org/OpenVPN/gdbuspp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
    platforms = lib.platforms.linux;
  };
})
