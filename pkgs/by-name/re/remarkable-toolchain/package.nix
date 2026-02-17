{
  lib,
  stdenv,
  fetchurl,
  libarchive,
  python3,
  file,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "remarkable-toolchain";
  version = "3.1.2";

  src = fetchurl {
    url = "https://storage.googleapis.com/remarkable-codex-toolchain/codex-x86_64-cortexa9hf-neon-rm10x-toolchain-${finalAttrs.version}.sh";
    sha256 = "sha256-ocODUUx2pgmqxMk8J+D+OvqlSHBSay6YzcqnxC9n59w=";
    executable = true;
  };

  nativeBuildInputs = [
    libarchive
    python3
    file
    which
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    ENVCLEANED=1 $src -y -d $out
  '';

  meta = {
    description = "Toolchain for cross-compiling to reMarkable tablets";
    homepage = "https://remarkable.engineering/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      nickhu
      siraben
    ];
    platforms = [ "x86_64-linux" ];
  };
})
