{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
  lua,
}:

stdenvNoCC.mkDerivation {
  pname = "librime-lua";
  version = "0-unstable-2026-08-31";

  src = fetchFromGitHub {
    owner = "hchunhui";
    repo = "librime-lua";
    rev = "ad1e4a6c98abf634dd34242a747f9b1d5d069fbe";
    hash = "sha256-Zi5VyFyLk4n34+TEDvV2HEYQKL60mEiVVLFKb6hWFdE=";
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
