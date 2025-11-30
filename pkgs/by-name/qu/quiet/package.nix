{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeWrapper,
  _7zz,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:

let
  pname = "quiet";
  version = "6.3.0";

  meta = {
    description = "Private, p2p alternative to Slack and Discord built on Tor & IPFS";
    homepage = "https://github.com/TryQuiet/quiet";
    changelog = "https://github.com/TryQuiet/quiet/releases/tag/@quiet/desktop@${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kashw2 ];
  };

  passthru.updateScript = writeShellScript "update-quiet" ''
    latestVersion=$(${lib.getExe curl} --fail --location --silent https://api.github.com/repos/TryQuiet/quiet/releases/latest | ${lib.getExe jq} '.tag_name | ltrimstr("@quiet/desktop@")' --raw-output)
    currentVersion=$(nix eval --raw --file . quiet.version)
    if [[ "$latestVersion" == "$currentVersion" ]]; then
      exit 0
    fi
    ${lib.getExe' common-updater-scripts "update-source-version"} quiet $latestVersion --system=x86_64-linux --ignore-same-hash
    hash=$(nix hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix eval --raw --file . quiet.src.url --system aarch64-darwin)))
    ${lib.getExe' common-updater-scripts "update-source-version"} quiet $latestVersion $hash --system=aarch64-darwin --ignore-same-version --ignore-same-hash
  '';

  linux = appimageTools.wrapType2 {
    inherit pname version passthru;

    src = fetchurl {
      url = "https://github.com/TryQuiet/quiet/releases/download/@quiet/desktop@${version}/Quiet-${version}.AppImage";
      hash = "sha256-LRUm2QMYg2oD6USOUYRyNUDf1VHu2txsaCUhbi1Ar5o=";
    };

    meta = meta // {
      platforms = [ "x86_64-linux" ];
    };
  };

  darwin = stdenv.mkDerivation {
    inherit pname version passthru;

    src = fetchurl {
      url = "https://github.com/TryQuiet/quiet/releases/download/@quiet/desktop@${version}/Quiet-${version}.dmg";
      hash = "sha256-T3EDgQ2DhYttbRjAklhw/C4paUzkdEx6i6Gi+Jx1N+w=";
    };

    nativeBuildInputs = [
      _7zz
      makeWrapper
    ];

    sourceRoot = "Quiet ${version}";

    unpackPhase = ''
      runHook preUnpack

      7zz x $src -x!Quiet\ ${version}/Applications

      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{Applications,bin}
      mv Quiet.app $out/Applications
      makeWrapper $out/Applications/Quiet.app/Contents/MacOS/Quiet $out/bin/${pname}

      runHook postInstall
    '';

    meta = meta // {
      platforms = lib.platforms.darwin;
    };
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
