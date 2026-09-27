{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  quickjs-ng,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "librime-qjs";
  version = "0-unstable-2025-03-14";

  src = fetchFromGitHub {
    owner = "HuangJian";
    repo = "librime-qjs";
    rev = "aee33c3adb729543c4cb67b9ca29a5f0d8866cf1";
    hash = "sha256-wgdWaDIpiU2XEoQLoyIs/8aeSGHYYhQILbq/GVdr1Z4=";
  };

  propagatedBuildInputs = [ quickjs-ng ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp --archive --verbose src/ tests/ $out
    install --mode=644 --verbose --target-directory=$out CMakeLists.txt LICENSE readme.md

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Bring a fresh JavaScript plugin ecosystem to the Rime Input Method Engine";
    homepage = "https://github.com/HuangJian/librime-qjs";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ xyenon ];
  };
}
