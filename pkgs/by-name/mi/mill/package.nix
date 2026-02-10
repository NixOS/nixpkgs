{
  autoPatchelfHook,
  fetchurl,
  jre,
  lib,
  makeWrapper,
  stdenvNoCC,
  zlib,
  writeScript,
  stdenv,
  curl,
  libxml2,
  common-updater-scripts,
}:

let
  suffixMap = {
    aarch64-darwin = "native-mac-aarch64";
    x86_64-darwin = "native-mac-amd64";
    aarch64-linux = "native-linux-aarch64";
    x86_64-linux = "native-linux-amd64";
  };
  suffix =
    suffixMap.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenvNoCC.mkDerivation rec {
  pname = "mill";
  version = "1.1.1";

  src = fetchurl {
    url = "https://repo1.maven.org/maven2/com/lihaoyi/mill-dist-${suffix}/${version}/mill-dist-${suffix}-${version}.exe";
    sha256 =
      {
        aarch64-darwin = "sha256-ItoUsQ2Hu6aCrVS9GGf/m6DrQyCwJqtvWT8cTJSnZw4=";
        x86_64-darwin = "sha256-9NLsUK3H3L27a+OO2kAyApezQpkHAJqvgYgQEXT6y9U=";
        aarch64-linux = "sha256-VaBjRHMBKB83dHACQor9R0Gk/7tCpw1ITkxqWJb9+KI=";
        x86_64-linux = "sha256-BMc7sGPlTzcED5RjrTNlrBWyr89cNiKfnh3plJ24dZ4=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  buildInputs = [ zlib ];
  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optional stdenvNoCC.hostPlatform.isLinux autoPatchelfHook;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  # this is mostly downloading a pre-built artifact
  preferLocal = true;

  installPhase = ''
    runHook preInstall

    install -Dm 555 $src $out/bin/.mill-wrapped
    # can't use wrapProgram because it sets --argv0
    makeWrapper $out/bin/.mill-wrapped $out/bin/mill \
      --prefix PATH : "${jre}/bin" \
      --set-default JAVA_HOME "${jre}"

    runHook postInstall
  '';

  passthru.updateScript = writeScript "${pname}-updater" ''
    #!${stdenv.shell}
    set -eu -o pipefail
    PATH=${
      lib.makeBinPath [
        curl
        libxml2 # xmllint
        common-updater-scripts
      ]
    }:$PATH
    metadataUrl="https://repo1.maven.org/maven2/com/lihaoyi/mill-dist/maven-metadata.xml"
    latestVersion="$(curl -sS $metadataUrl | xmllint --xpath '/metadata/versioning/release/text()' -)"

    ${lib.strings.concatStrings (
      builtins.map (
        platform:
        let
          suffix = suffixMap.${platform} or (throw "Platform not in suffixMap: ${platform}");
        in
        ''
          {
            dlUrl="https://repo1.maven.org/maven2/com/lihaoyi/mill-dist-${suffix}/$latestVersion/mill-dist-${suffix}-$latestVersion.exe"

            prefetch="$(nix-prefetch-url $dlUrl)"
            hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri $prefetch)


            update-source-version mill "$latestVersion" "$hash" --system=${platform} --ignore-same-version
          }
        ''
      ) meta.platforms
    )}
  '';

  meta = {
    homepage = "https://com-lihaoyi.github.io/mill/";
    license = lib.licenses.mit;
    description = "Build tool for Scala, Java and more";
    mainProgram = "mill";
    longDescription = ''
      Mill is a build tool borrowing ideas from modern tools like Bazel, to let you build
      your projects in a way that's simple, fast, and predictable. Mill has built in
      support for the Scala programming language, and can serve as a replacement for
      SBT, but can also be extended to support any other language or platform via
      modules (written in Java or Scala) or through an external subprocesses.
    '';
    maintainers = with lib.maintainers; [
      zenithal
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
