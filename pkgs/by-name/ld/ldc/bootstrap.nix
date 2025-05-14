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

let
  inherit (stdenv) hostPlatform;
  OS = if hostPlatform.isDarwin then "osx" else hostPlatform.parsed.kernel.name;
  ARCH =
    if hostPlatform.isDarwin && hostPlatform.isAarch64 then "arm64" else hostPlatform.parsed.cpu.name;
  # Work around macOS Sequoia 15.4 segfault by downgrading the bootstrap compiler - see:
  # - https://github.com/NixOS/nixpkgs/issues/398443
  # - https://github.com/dlang/dmd/issues/21126#issuecomment-2775948553
  # TODO: Remove this when bootstrap can be upgraded to a fixed version (>= 1.41.0-beta2)?
  version = if hostPlatform.isDarwin then "1.28.1" else "1.30.0";
  hashes = {
    # Get these from `nix store prefetch-file https://github.com/ldc-developers/ldc/releases/download/v1.19.0/ldc2-1.19.0-osx-x86_64.tar.xz` etc..
    osx-x86_64 = "sha256-mqQ+hNlDePOGX2mwgEEzHGiOAx3SxfNA6x8+ML3qYmw=";
    linux-x86_64 = "sha256-V4TUzEfQhFrwiX07dHOgjdAoGkzausCkhnQIQNAU/eE=";
    linux-aarch64 = "sha256-kTeglub75iv/jWWNPCn15aCGAbmck0RQl6L7bFOUu7Y=";
    osx-arm64 = "sha256-m93rGywncBnPEWslcrXuGBnZ+Z/mNgLIaevkL/uBOu0=";
  };
in
stdenv.mkDerivation {
  pname = "ldc-bootstrap";
  inherit version;

  src = fetchurl rec {
    name = "ldc2-${version}-${OS}-${ARCH}.tar.xz";
    url = "https://github.com/ldc-developers/ldc/releases/download/v${version}/${name}";
    hash = hashes."${OS}-${ARCH}" or (throw "missing bootstrap hash for ${OS}-${ARCH}");
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs =
    lib.optionals hostPlatform.isLinux [
      autoPatchelfHook
    ]
    ++ lib.optional hostPlatform.isDarwin fixDarwinDylibNames;

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

  meta = with lib; {
    description = "LLVM-based D Compiler";
    homepage = "https://github.com/ldc-developers/ldc";
    # from https://github.com/ldc-developers/ldc/blob/master/LICENSE
    license = with licenses; [
      bsd3
      boost
      mit
      ncsa
      gpl2Plus
    ];
    maintainers = with maintainers; [ lionello ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
