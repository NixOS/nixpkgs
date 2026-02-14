{
  lib,
  clangStdenv,
  fetchFromGitHub,
  buildPackages,
  libsodium,
  libseccomp,
  libcap,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "nacrypt";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "basicallygit";
    repo = "nacrypt";
    tag = finalAttrs.version;
    hash = "sha256-wR+41Ev7LFaSIEuJckJbiFPj57WeiE1xhcB1/k1ktyU=";
  };

  nativeBuildInputs = [
    buildPackages.bash
    buildPackages.clang-tools
  ];

  buildInputs = [
    libsodium
    libseccomp
    libcap
  ];

  postPatch = ''
    chmod +x format.sh
    patchShebangs format.sh
  '';

  # Allow sandbox fail for systems without unprivileged usernamespaces enabled
  makeFlags = [
    "CLANG_CFI=y"
    "TIGHTENED_SANDBOX=y"
    "ALLOW_SANDBOX_FAIL=y"
  ];

  doCheck = true;
  checkTarget = "test";

  installPhase = ''
    runHook preInstall
    install -Dm755 nacrypt $out/bin/nacrypt
    runHook postInstall
  '';

  meta = {
    description = "Simple and secure file encryption utility";
    homepage = "https://github.com/basicallygit/nacrypt";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ basicallygit ];
    mainProgram = "nacrypt";
  };
})
