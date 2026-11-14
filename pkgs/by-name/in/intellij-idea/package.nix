{
  # keep-sorted start
  autoPatchelfHook,
  fetchurl,
  fsnotifier,
  jdk25_headless,
  jetbrains,
  jetbrains-libdbm,
  lib,
  lldb,
  maven,
  musl,
  stdenv,
  zlib,
  # keep-sorted end
}:
let
  inherit (stdenv.hostPlatform) system;
  versionInfo = lib.importJSON ./version.json;

  profilerBinaryDirNames = {
    x86_64-linux = "linux";
    aarch64-linux = "linux-aarch64";
  };
in
jetbrains.mkJetBrainsProduct (finalAttrs: {
  inherit jetbrains-libdbm fsnotifier;
  inherit (versionInfo) version buildNumber;

  pname = "intellij-idea";

  wmClass = "jetbrains-idea";
  product = "IntelliJ IDEA";
  productShort = "IDEA";

  src = fetchurl (versionInfo.urls.${system} or (throw "Unsupported system: ${system}"));

  # the jdk is bundled on Darwin.
  jdk =
    if lib.meta.availableOn stdenv.hostPlatform jetbrains.jdk-no-jcef then
      jetbrains.jdk-no-jcef
    else
      null;

  extraLdPath = [ zlib ];
  extraWrapperArgs = [
    ''--set M2_HOME "${maven}/maven"''
    ''--set M2 "${maven}/maven/bin"''
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    jdk25_headless
    autoPatchelfHook
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    # keep-sorted start
    lldb
    musl
    # keep-sorted end
  ];

  profilerBinaryDirName = profilerBinaryDirNames.${stdenv.hostPlatform.system} or "";
  postFixup = ''
    if [[ -n "$profilerBinaryDirName" ]]; then
      echo "Unpacking intellij.profiler.asyncOne.jar"
      echo "exec jar --extract --file $out/${finalAttrs.pname}/lib/intellij.profiler.asyncOne.jar -C profilerJarContents"
      jar --extract --file $out/${finalAttrs.pname}/lib/intellij.profiler.asyncOne.jar -C profilerJarContents

      pushd profilerJarContents

      echo "Patching jattach"
      autoPatchelf binaries/$profilerBinaryDirName/jattach
      echo "Repacking jar"
      jar --create --file $out/${finalAttrs.pname}/lib/intellij.profiler.asyncOne.jar *

      popd

      rm -r profilerJarContents
    fi
  '';

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/idea/";
    description = "Java, Kotlin, Groovy and Scala IDE from JetBrains";
    longDescription = ''
      IDE for Java SE, Groovy & Scala development Powerful environment for building Google Android apps Integration with JUnit, TestNG, popular SCMs, Ant & Maven.
      Also known as IntelliJ.
    '';
    maintainers = with lib.maintainers; [
      gytis-ivaskevicius
      tymscar
    ];
    teams = [ lib.teams.jetbrains ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
})
