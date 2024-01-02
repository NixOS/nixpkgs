{ stdenv
, lib
, fetchFromSourcehut
, hare
, scdoc
, nix-update-script
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "haredo";
  version = "1.0.5";

  outputs = [ "out" "man" ];

  src = fetchFromSourcehut {
    owner = "~autumnull";
    repo = "haredo";
    rev = finalAttrs.version;
    hash = "sha256-gpui5FVRw3NKyx0AB/4kqdolrl5vkDudPOgjHc/IE4U=";
  };

  nativeBuildInputs = [
    hare
    scdoc
  ];

  preBuild = ''
    HARECACHE="$(mktemp -d --tmpdir harecache.XXXXXXXX)"
    export HARECACHE
    export PREFIX=${builtins.placeholder "out"}
  '';

  buildPhase = ''
    runHook preBuild

    ./bootstrap.sh

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    ./bin/haredo test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    ./bootstrap.sh install

    runHook postInstall
  '';

  dontConfigure = true;
  doCheck = true;

  setupHook = ./setup-hook.sh;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A simple and unix-idiomatic build automator";
    homepage = "https://sr.ht/~autumnull/haredo/";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ onemoresuza ];
    mainProgram = "haredo";
    inherit (hare.meta) platforms badPlatforms;
  };
})
