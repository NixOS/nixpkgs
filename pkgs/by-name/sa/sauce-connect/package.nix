{
  stdenv,
  lib,
  fetchurl,
  zlib,
  unzip,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "sauce-connect";
  version = "5.5.1";

  passthru = {
    sources = {
      x86_64-linux = fetchurl {
        url = "https://saucelabs.com/downloads/sauce-connect/${version}/sauce-connect-${version}_linux.x86_64.tar.gz";
        hash = "sha256-jgyQCJ+MA3NXIGtc5rxQf+nkfEy/rYJysCxXos5B4Fs=";
      };
      aarch64-linux = fetchurl {
        url = "https://saucelabs.com/downloads/sauce-connect/${version}/sauce-connect-${version}_linux.aarch64.tar.gz";
        hash = "sha256-mJajGN0pqmjUuxlq0GxXZb8qk1aE4Ea0LFtN5eL7YXM=";
      };
      x86_64-darwin = fetchurl {
        url = "https://saucelabs.com/downloads/sauce-connect/${version}/sauce-connect-${version}_darwin.all.zip";
        hash = "sha256-d4yfKXfTFEvL5+2Mu85Rwax1qN8VWsoil6JOLKPfjrw=";
      };
      aarch64-darwin = passthru.sources.x86_64-darwin;
    };
    updateScript = ./update.sh;
  };

  src =
    passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  unpackPhase = ''
    runHook preUnpack

    mkdir source
    ${lib.optionalString stdenv.hostPlatform.isLinux "tar -zxvf $src -C source"}
    ${lib.optionalString stdenv.hostPlatform.isDarwin "unzip $src -d source"}

    runHook postUnpack
  '';

  sourceRoot = "source";

  nativeBuildInputs = [
    unzip
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 sc $out/bin/sc
    installShellCompletion --bash --name sc.bash completions/sc.bash
    installShellCompletion --fish --name sc.fish completions/sc.fish
    installShellCompletion --zsh --name _sc completions/sc.zsh
    install -Dm644 LICENSE $out/share/licenses/sauce-connect/LICENSE
    install -Dm644 LICENSE.3RD_PARTY $out/share/licenses/sauce-connect/LICENSE.3RD_PARTY
    install -Dm644 sauce-connect.yaml $out/etc/sauce-connect.yaml

    runHook postInstall
  '';

  dontStrip = true;

  meta = {
    description = "Secure tunneling app for executing tests securely when testing behind firewalls";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    homepage = "https://docs.saucelabs.com/reference/sauce-connect/";
    maintainers = [ ];
    platforms = builtins.attrNames passthru.sources;
  };
}
