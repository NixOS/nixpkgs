{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
  lua,
}:

stdenvNoCC.mkDerivation {
  pname = "librime-lua";
  version = "0-unstable-2026-09-30";

  src = fetchFromGitHub {
    owner = "hchunhui";
    repo = "librime-lua";
    rev = "6f30968058a3ca83c47949308ef0ddc51a11a264";
    hash = "sha256-drq6xHgcXXyEAUdR3p+5OvJememQGOrI1a5WfJ0+oLU=";
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
