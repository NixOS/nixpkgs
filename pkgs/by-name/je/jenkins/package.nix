{
  lib,
  stdenv,
  fetchurl,
  common-updater-scripts,
  coreutils,
  git,
  gnused,
  makeWrapper,
  nix,
  jdk21,
  writeScript,
  nixosTests,
  jq,
  cacert,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jenkins";
  version = "2.504.1";

  src = fetchurl {
    url = "https://get.jenkins.io/war-stable/${finalAttrs.version}/jenkins.war";
    hash = "sha256-gQJtsYsMSq1rYs9AjkxC5Xl2YbQcUXs332BiOOibnfE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p "$out/bin" "$out/share" "$out/webapps"

    cp "$src" "$out/webapps/jenkins.war"

    # Create the `jenkins-cli` command.
    ${jdk21}/bin/jar -xf "$src" WEB-INF/lib/cli-${finalAttrs.version}.jar \
      && mv WEB-INF/lib/cli-${finalAttrs.version}.jar "$out/share/jenkins-cli.jar"

    makeWrapper "${jdk21}/bin/java" "$out/bin/jenkins-cli" \
      --add-flags "-jar $out/share/jenkins-cli.jar"
  '';

  passthru = {
    tests = { inherit (nixosTests) jenkins jenkins-cli; };

    updateScript = writeScript "update.sh" ''
      #!${stdenv.shell}
      set -o errexit
      PATH=${
        lib.makeBinPath [
          cacert
          common-updater-scripts
          coreutils
          curl
          git
          gnused
          jq
          nix
        ]
      }

      core_json="$(curl -s --fail --location https://updates.jenkins.io/stable/update-center.actual.json | jq .core)"
      oldVersion=$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion jenkins" | tr -d '"')

      version="$(jq -r .version <<<$core_json)"
      sha256="$(jq -r .sha256 <<<$core_json)"
      hash="$(nix hash to-sri --type sha256 "$sha256")"

      if [ ! "$oldVersion" = "$version" ]; then
        update-source-version jenkins "$version" "$hash"
      else
        echo "jenkins is already up-to-date"
      fi
    '';
  };

  meta = with lib; {
    description = "Extendable open source continuous integration server";
    homepage = "https://jenkins.io/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = with maintainers; [
      earldouglas
      nequissimus
    ];
    changelog = "https://www.jenkins.io/changelog-stable/#v${finalAttrs.version}";
    mainProgram = "jenkins-cli";
    platforms = platforms.all;
  };
})
