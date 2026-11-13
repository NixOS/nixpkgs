{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
  lua5_2_compat,
}:
let
  lua = lua5_2_compat;
in

stdenvNoCC.mkDerivation {
  pname = "librime-lua";
  version = "0-unstable-2026-10-10";

  src = fetchFromGitHub {
    owner = "hchunhui";
    repo = "librime-lua";
    rev = "6da5d6cedb853380ed1b5b9b6979cb1a9c028353";
    hash = "sha256-zEgTdBf8Qjd++kaWkPY+2FEOgPYufspNQPFG52QZkUo=";
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
