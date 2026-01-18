{
  fetchFromGitHub,
  lib,
  python3,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cupp";
  version = "0-unstable-2025-12-26";

  src = fetchFromGitHub {
    owner = "mebus";
    repo = "cupp";
    rev = "616a7b0c01b9cec51954df86a2a538dffcba3834";
    hash = "sha256-s2yxQwth5CsPU0D10OpoKSCj0Q71ybWj13Rwu+75Xws=";
  };

  postPatch = ''
    substituteInPlace cupp.py \
      --replace-fail /usr/bin/python3 ${lib.getExe python3} \
      --replace-fail cupp.cfg ${placeholder "out"}/lib/cupp.cfg
  '';

  installPhase = ''
    runHook preInstall

    install -D cupp.py $out/bin/${finalAttrs.meta.mainProgram}
    install -Dm644 cupp.cfg --target-directory=$out/lib

    runHook postInstall
  '';

  meta = {
    description = "Common User Passwords Profiler";
    homepage = "https://github.com/mebus/cupp";
    changelog = "https://github.com/mebus/cupp/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "cupp";
    platforms = lib.platforms.all;
  };
})
