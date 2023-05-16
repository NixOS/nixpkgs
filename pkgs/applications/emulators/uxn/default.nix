{ lib
, stdenv
, fetchFromSourcehut
, SDL2
<<<<<<< HEAD
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uxn";
  version = "unstable-2023-08-30";
=======
}:

stdenv.mkDerivation {
  pname = "uxn";
  version = "unstable-2022-10-22";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromSourcehut {
    owner = "~rabbits";
    repo = "uxn";
<<<<<<< HEAD
    rev = "cfd29ac5119e5b270d5f3e3e9e29d020dadef8d3";
    hash = "sha256-0fE9M+IEKTBG0WLKEbXG1kAJv19TrQWTFMjedOyX8N0=";
  };

  outputs = [ "out" "projects" ];

  nativeBuildInputs = [
    SDL2
  ];

=======
    rev = "1b2049e238df96f32335edf1c6db35bd09f8b42d";
    hash = "sha256-lwms+qUelfpTC+i2m5b3dW7ww9298YMPFdPVsFrwcDQ=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    SDL2
  ];

<<<<<<< HEAD
  strictDeps = true;

  postPatch = ''
    patchShebangs build.sh
    substituteInPlace build.sh \
      --replace "-L/usr/local/lib " "" \
      --replace "\$(brew --prefix)/lib/libSDL2.a " ""
=======
  dontConfigure = true;

  postPatch = ''
     sed -i -e 's|UXNEMU_LDFLAGS="$(brew.*$|UXNEMU_LDFLAGS="$(sdl2-config --cflags --libs)"|' build.sh
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh --no-run

    runHook postBuild
  '';

<<<<<<< HEAD
  # ./build.sh --install is meant to install in $HOME, therefore not useful for
  # package maintainers
  installPhase = ''
    runHook preInstall

    install -d $out/bin/
    cp bin/uxnasm bin/uxncli bin/uxnemu $out/bin/
    install -d $projects/share/uxn/
    cp -r projects $projects/share/uxn/
=======
  installPhase = ''
    runHook preInstall

    install -d $out/bin/ $out/share/uxn/

    cp bin/uxnasm bin/uxncli bin/uxnemu $out/bin/
    cp -r projects $out/share/uxn/
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postInstall
  '';

<<<<<<< HEAD
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
=======
  meta = with lib; {
    homepage = "https://wiki.xxiivv.com/site/uxn.html";
    description = "An assembler and emulator for the Uxn stack machine";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ AndersonTorres kototama ];
    platforms = with platforms; unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
