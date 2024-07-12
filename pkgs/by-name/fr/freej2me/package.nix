{
  lib,
  stdenv,
  fetchFromGitHub,
  ant,
  jdk19,
  stripJavaArchivesHook,
  writeShellScriptBin,
}:

stdenv.mkDerivation {
  pname = "freej2me";
  # Requested release at https://github.com/hex007/freej2me/issues/220
  version = "0-unstable-2024-02-16";

  src = fetchFromGitHub {
    owner = "hex007";
    repo = "freej2me";
    rev = "8b9bc8a19baf26e3d92f88934a64a32f1cbc2795";
    hash = "sha256-FaB2qnbtJnSZbrGRYDiz3Q/uNgD4GX//VaID6jHtyeU=";
  };

  nativeBuildInputs = [
    ant
    jdk19
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild

    ant
    make -C src/libretro

    runHook postBuild
  '';

  installPhase = let
    mk-script-bin = front-end: writeShellScriptBin front-end ''
      if [ "$#" != 3 ]; then
        echo "usage: ${front-end} [midlet] [width] [height]"
        exit 2
      fi

      ${lib.getExe' jdk19 "java"} -jar        \
        "@out@/share/java/${front-end}.jar" \
        "file://$(realpath "$1")" $2 $3
    '';

    mk-script-install = front-end: ''
      install -D --mode=755 --verbose \
        ${mk-script-bin front-end}/bin/${front-end} --target-directory=$out/bin

      substituteInPlace $out/bin/${front-end} \
        --replace-fail "@out@" "${placeholder "out"}"
    '';

    front-ends = [ "freej2me" "freej2me-lr" ];
    install-scripts = builtins.map mk-script-install front-ends;
  in ''
    runHook preInstall

    install -D --mode=644 --verbose \
      build/freej2me{,-lr}.jar --target-directory=$out/share/java

    ${builtins.concatStringsSep "\n" install-scripts}

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/hex007/freej2me";
    description = "Free J2ME emulator with libretro, awt and sdl2 frontends";
    # From LICENSE file: "FreeJ2ME depends on ObjectWeb ASM"
    # ObjectWeb ASM License is 3-clause BSD
    license = with lib.licenses; [ gpl3Plus bsd3 ];
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "freej2me";
    platforms = lib.platforms.all;
  };
}
