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
  version = "9.0.2";

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

    # Quiet invokes pgrep and ps when managing its bundled Tor process. Without them, Tor startup fails with command not found.
    extraPkgs = pkgs: [ pkgs.procps ];

    src = fetchurl {
      url = "https://github.com/TryQuiet/quiet/releases/download/@quiet/desktop@${version}/Quiet-${version}.AppImage";
      hash = "sha256-CRQoTc7BbsWeA+6+X5ZjPYHNT4dqd1xZb6b2P83kC90=";
    };

    meta = meta // {
      platforms = [ "x86_64-linux" ];
    };
  };

  darwin = stdenv.mkDerivation {
    inherit pname version passthru;

    src = fetchurl {
      url = "https://github.com/TryQuiet/quiet/releases/download/@quiet/desktop@${version}/Quiet-${version}-arm64.dmg";
      hash = "sha256-G4Hj3YTsVX5Q3x4RnpXI6FPovm9fKXrfaUsZJ5EEUl8=";
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
