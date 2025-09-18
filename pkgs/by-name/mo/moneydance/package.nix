{
  lib,
  stdenv,
  buildPackages,
  fetchzip,
  makeWrapper,
  openjdk23,
  wrapGAppsHook3,
  jvmFlags ? [ ],
}:
let
  jdk = openjdk23.override {
    enableJavaFX = true;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "moneydance";
  version = "2024.4_5253";

  src = fetchzip {
    url = "https://infinitekind.com/stabledl/${
      lib.replaceStrings [ "_" ] [ "." ] finalAttrs.version
    }/moneydance-linux.tar.gz";
    hash = "sha256-xOdkuaN17ss9tTSXgU//s6cBm2jGEgP9eTtvW0k3VWQ=";
  };

  # We must use wrapGAppsHook (since Java GUIs on Linux use GTK), but by
  # default that uses makeBinaryWrapper which doesn't support flags that need
  # quoting: <https://github.com/NixOS/nixpkgs/issues/330471>. Thanks to
  # @Artturin for the tip to override the wrapper generator.
  nativeBuildInputs = [
    makeWrapper
    (buildPackages.wrapGAppsHook3.override { makeWrapper = buildPackages.makeShellWrapper; })
  ];
  buildInputs = [ jdk ];
  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec $out/bin
    cp -p $src/lib/* $out/libexec/

    runHook postInstall
  '';

  # Note the double escaping in the call to makeWrapper. The escapeShellArgs
  # call quotes each element of the flags list as a word[1] and returns a
  # space-separated result; the escapeShellArg call quotes that result as a
  # single word to pass to --add-flags. The --add-flags implementation[2]
  # loops over the words in its argument.
  #
  # 1. https://www.gnu.org/software/bash/manual/html_node/Word-Splitting.html
  # 2. https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
  postFixup =
    let
      finalJvmFlags = [
        "-client"
        "--add-modules"
        "javafx.swing,javafx.controls,javafx.graphics"
        "-classpath"
        "${placeholder "out"}/libexec/*"
      ]
      ++ jvmFlags
      ++ [ "Moneydance" ];
    in
    ''
      # This is in postFixup because gappsWrapperArgs is generated in preFixup
      makeWrapper ${jdk}/bin/java $out/bin/moneydance \
        "''${gappsWrapperArgs[@]}" \
        --add-flags ${lib.escapeShellArg (lib.escapeShellArgs finalJvmFlags)}
    '';

  passthru = {
    inherit jdk;
  };

  meta = {
    homepage = "https://infinitekind.com/moneydance";
    changelog = "https://infinitekind.com/stabledl/${
      lib.replaceStrings [ "_" ] [ "." ] finalAttrs.version
    }/changelog-stable.txt";
    description = "Easy to use and full-featured personal finance app that doesn't compromise your privacy";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.unfree;
    # Darwin refers to Zulu Java, which breaks the evaluation of this derivation
    # for some reason
    #
    # https://github.com/NixOS/nixpkgs/pull/306372#issuecomment-2111688236
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.lucasbergman ];
  };
})
