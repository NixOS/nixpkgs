{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "kvmarwaita";
  version = "0-unstable-2024-06-27";

  src = fetchFromGitHub {
    owner = "darkomarko42";
    repo = "KvMarwaita";
    rev = "3e5f62b8e23bde87f04aae157a453e380d6c5460";
    hash = "sha256-5hRqWQR1OZK7I5T8NV2D1i5yrifvWhHakgwGtdtQQPQ=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/Kvantum/KvMarwaita
    cp -a Kv* $out/share/Kvantum/KvMarwaita/
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Marwaita theme for Kvantum";
    homepage = "https://github.com/darkomarko42/KvMarwaita";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ romildo ];
  };
}
