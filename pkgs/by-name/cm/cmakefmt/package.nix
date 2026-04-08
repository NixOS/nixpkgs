{
  lib,
  fetchurl,
  stdenv,
  autoPatchelfHook,
  gcc-unwrapped,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cmakefmt";
  version = "0.2.0";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/cmakefmt/cmakefmt/releases/download/v${finalAttrs.version}/cmakefmt-${finalAttrs.version}-x86_64-unknown-linux-musl.tar.gz";
        hash = "sha256-Ps/6tIObs97gTbwJIkAbNsL/fVAW5Of2DP+PrmWhlIE=";
      }
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      fetchurl {
        url = "https://github.com/cmakefmt/cmakefmt/releases/download/v${finalAttrs.version}/cmakefmt-${finalAttrs.version}-aarch64-unknown-linux-gnu.tar.gz";
        hash = "sha256-VWLw4MHegWfLnjKIBDlKpYO3e3rvApAEE2vD9yRGPew=";
      }
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      fetchurl {
        url = "https://github.com/cmakefmt/cmakefmt/releases/download/v${finalAttrs.version}/cmakefmt-${finalAttrs.version}-x86_64-apple-darwin.tar.gz";
        hash = "sha256-4L1cAECf9MMiAUCnwfSc71py5ldUCfeCiXtAQ0/oOns=";
      }
    else if stdenv.hostPlatform.system == "aarch64-darwin" then
      fetchurl {
        url = "https://github.com/cmakefmt/cmakefmt/releases/download/v${finalAttrs.version}/cmakefmt-${finalAttrs.version}-aarch64-apple-darwin.tar.gz";
        hash = "sha256-RoNHwgt2TJi1rkMzrfMT+AlUSjHY+bLQyXJIKGm2n68=";
      }
    else
      throw "cmakefmt: unsupported system ${stdenv.hostPlatform.system}";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals (stdenv.isLinux && stdenv.hostPlatform.system == "aarch64-linux") [
    gcc-unwrapped.lib
  ];

  unpackPhase = ''
    tar -xzf $src
    cd cmakefmt-${finalAttrs.version}-*
  '';

  installPhase = ''
    install -Dm755 cmakefmt $out/bin/cmakefmt
  '';

  meta = {
    description = "A fast, correct CMake formatter";
    longDescription = ''
      cmakefmt is a fast, correct, configurable CMake formatter written in
      Rust. It is a native-binary drop-in replacement for cmake-format with
      full legacy config conversion support.
    '';
    homepage = "https://cmakefmt.dev";
    changelog = "https://github.com/cmakefmt/cmakefmt/blob/main/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ puneetmatharu ];
    mainProgram = "cmakefmt";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
