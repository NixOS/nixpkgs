{
  lib,
  stdenv,
  fetchurl,
  curl,
  tzdata,
  autoPatchelfHook,
  fixDarwinDylibNames,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ldc-bootstrap";
  version = "1.42.0";

  passthru.tarballs =
    let
      fetchPrebuilt =
        { platform, hash }:
        fetchurl {
          url = "https://github.com/ldc-developers/ldc/releases/download/v${finalAttrs.version}/ldc2-${finalAttrs.version}-${platform}.tar.xz";
          inherit hash;
        };
    in
    {
      "x86_64-linux" = fetchPrebuilt {
        platform = "linux-x86_64";
        hash = "sha256-p7yclWE49VjK35yWI1L1nUHIDfbrOuP4A58lvhSmkwM=";
      };
      "aarch64-linux" = fetchPrebuilt {
        platform = "linux-aarch64";
        hash = "sha256-aHcHw+IP+RBSjrLZLyepjLCWAoTeOwJua/IChKwchRE=";
      };
      "aarch64-darwin" = fetchPrebuilt {
        platform = "osx-arm64";
        hash = "sha256-emjiHFMFdmp09HNsyJGnlC23hCqSJmIyCVBLyFxwE4I=";
      };
    };

  src =
    finalAttrs.passthru.tarballs.${stdenv.hostPlatform.system}
      or (throw "missing prebuilt bootstrap tarball for ${stdenv.hostPlatform.system}");

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libxml2
    stdenv.cc.cc
  ];

  propagatedBuildInputs = [
    curl
    tzdata
  ];

  installPhase = ''
    mkdir -p $out

    mv bin etc import lib LICENSE README $out/
  '';

  meta = {
    description = "LLVM-based D Compiler";
    homepage = "https://github.com/ldc-developers/ldc";
    # from https://github.com/ldc-developers/ldc/blob/master/LICENSE
    license = with lib.licenses; [
      bsd3
      boost
      mit
      ncsa
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ lionello ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
