{ lib
, stdenv
, fetchFromSourcehut
, SDL2
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uxn";
  version = "unstable-2023-08-30";

  src = fetchFromSourcehut {
    owner = "~rabbits";
    repo = "uxn";
    rev = "cfd29ac5119e5b270d5f3e3e9e29d020dadef8d3";
    hash = "sha256-0fE9M+IEKTBG0WLKEbXG1kAJv19TrQWTFMjedOyX8N0=";
  };

  outputs = [ "out" "projects" ];

  nativeBuildInputs = [
    SDL2
  ];

  buildInputs = [
    SDL2
  ];

  strictDeps = true;

  postPatch = ''
    patchShebangs build.sh
    substituteInPlace build.sh \
      --replace "-L/usr/local/lib " "" \
      --replace "\$(brew --prefix)/lib/libSDL2.a " ""
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh --no-run

    runHook postBuild
  '';

  # ./build.sh --install is meant to install in $HOME, therefore not useful for
  # package maintainers
  installPhase = ''
    runHook preInstall

    install -d $out/bin/
    cp bin/uxnasm bin/uxncli bin/uxnemu $out/bin/
    install -d $projects/share/uxn/
    cp -r projects $projects/share/uxn/

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://wiki.xxiivv.com/site/uxn.html";
    description = "An assembler and emulator for the Uxn stack machine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    mainProgram = "uxnemu";
    inherit (SDL2.meta) platforms;
    # ofborg complains about an error trying to link inexistent SDL2 library
    # For full logs, run:
    # 'nix log /nix/store/bmyhh0lpifl9swvkpflqldv43vcrgci1-uxn-unstable-2023-08-10.drv'.
    broken = stdenv.isDarwin;
  };
})
