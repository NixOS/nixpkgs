{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  installShellFiles,
  capstone,
  libpng,
  libyaml,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sm64tools";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "queueRAM";
    repo = "sm64tools";
    tag = "sm64extendv${finalAttrs.version}";
    hash = "sha256-fFbSuwSV6USxxjGx0Zn/TCEyqggQeNcHruyiPf41ts0=";
    fetchSubmodules = true;
  };

  hardeningDisable = [ "format" ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    installShellFiles
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];

  buildInputs = [
    capstone
    libpng
    libyaml
    zlib
  ];

  installPhase = ''
    runHook preInstall

    installBin {f3d,f3d2obj,mio0,mipsdisasm,n64cksum,n64graphics,n64split,sm64compress,sm64extend,sm64geo,sm64walk}

    runHook postInstall
  '';

  meta = {
    description = "Collection of tools for Super Mario 64 ROM hacking";
    homepage = "https://github.com/queueRAM/sm64tools";
    license = with lib.licenses; [
      mit
      unfree # reverse engineering
    ];
    maintainers = with lib.maintainers; [ qubitnano ];
    platforms = lib.platforms.linux;
  };
})
