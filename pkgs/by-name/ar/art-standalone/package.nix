{
  lib,
  stdenv,
  fetchFromGitLab,
  wolfssl,
  bionic-translation,
  python3,
  which,
  jdk17,
  zip,
  xz,
  icu,
  zlib,
  libcap,
  expat,
  openssl,
  libbsd,
  lz4,
  runtimeShell,
  libpng,
  makeWrapper,
  binutils,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "art-standalone";
  version = "0-unstable-2025-07-09";

  src = fetchFromGitLab {
    owner = "android_translation_layer";
    repo = "art_standalone";
    rev = "1eee3dce3ba6f324bb7a32a170b2da14889af39d";
    hash = "sha256-OAO0k/LkQ+MKqR4HkFXD18LSXQZNPogjjRot4UVoE5A=";
  };

  patches = [
    # Do not hardocde addr2line binary path
    ./no-hardcode-path-addr2line.patch

    # Add support for pkg-config
    # See: https://gitlab.com/android_translation_layer/art_standalone/-/merge_requests/37
    ./pkg-config-support.patch
  ];

  postPatch = ''
    chmod +x dalvik/dx/etc/{dx,dexmerger}
    patchShebangs .
    sed -i "s|/bin/bash|${runtimeShell}|" build/core/config.mk build/core/main.mk
  '';

  enableParallelBuilding = true;

  strictDeps = true;

  nativeBuildInputs = [
    jdk17
    makeWrapper
    python3
    which
    zip
  ];

  buildInputs = [
    bionic-translation
    expat
    icu
    libbsd
    libcap
    libpng
    lz4
    openssl
    (wolfssl.overrideAttrs (oldAttrs: {
      configureFlags = oldAttrs.configureFlags ++ [
        "--enable-jni"
      ];
      # Disable failing tests when jni enabled
      postPatch = oldAttrs.postPatch or "" + ''
        sed -i '/TEST_DECL(test_wolfSSL_Tls13_ECH)/d;
                /TEST_DECL(test_wolfSSL_Tls13_ECH_HRR)/d;
                /TEST_DECL(test_TLSX_CA_NAMES_bad_extension)/d' tests/api.c
        sed -i '/quic/d' tests/include.am
        sed -i '300,305d' tests/unit.c
      '';
    }))
    xz
    zlib
  ];

  makeFlags = [
    "____LIBDIR=lib"
    "____PREFIX=${placeholder "out"}"
    "____INSTALL_ETC=${placeholder "out"}/etc"
  ];

  postFixup = ''
    wrapProgram $out/bin/dx \
      --prefix LD_LIBRARY_PATH : $out/lib \
      --prefix PATH : ${lib.makeBinPath [ binutils ]}
  '';

  meta = {
    description = "Art and dependencies with modifications to make it work on Linux";
    homepage = "https://gitlab.com/android_translation_layer/art_standalone";
    # No license specified yet
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ onny ];
  };
})
