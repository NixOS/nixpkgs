{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
  lua,
}:

stdenvNoCC.mkDerivation {
  pname = "librime-lua";
  version = "0-unstable-2025-07-07";

  src = fetchFromGitHub {
    owner = "hchunhui";
    repo = "librime-lua";
    rev = "68f9c364a2d25a04c7d4794981d7c796b05ab627";
    hash = "sha256-m7/qXdIlMMHscDDcFmusNuOR0cuzPpDQdprqRci8qZw=";
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
