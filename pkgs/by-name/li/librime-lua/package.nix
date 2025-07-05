{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
  lua,
}:

stdenvNoCC.mkDerivation {
  pname = "librime-lua";
  version = "0-unstable-2025-07-03";

  src = fetchFromGitHub {
    owner = "hchunhui";
    repo = "librime-lua";
    rev = "150e754a877e03d1e0c3763883382bae0de6df20";
    hash = "sha256-aoF9jW32EVbZNPfMgPqCN+HGw3iFTbwc1TWHZLsmb0A=";
  };

  propagatedBuildInputs = [ lua ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp --archive --verbose src/ $out
    install --mode=644 --verbose --target-directory=$out CMakeLists.txt  LICENSE  README.md

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Extending RIME with Lua scripts";
    homepage = "https://github.com/hchunhui/librime-lua";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      linj
      xddxdd
    ];
  };
}
