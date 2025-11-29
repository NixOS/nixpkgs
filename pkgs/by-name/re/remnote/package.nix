{
  lib,
  fetchurl,
  appimageTools,
  writeScript,
}:
let
  pname = "remnote";
  version = "1.22.23";
  src = fetchurl {
    url = "https://download2.remnote.io/remnote-desktop2/RemNote-${version}.AppImage";
    hash = "sha256-8AliWnmYemaF6R7MGiU+H0ZwVw5hZRIbMHuGo4p+NQg=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/remnote.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/remnote.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=remnote %u'
    install -Dm444 ${appimageContents}/remnote.png -t $out/share/pixmaps
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl coreutils gnused common-updater-scripts
    set -eu -o pipefail
    url="$(curl -ILs -w %{url_effective} -o /dev/null https://backend.remnote.com/desktop/linux)"
    version="$(echo $url | sed -n 's/.*RemNote-\([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/p')"
    currentVersion=$(nix-instantiate --eval -E "with import ./. {}; remnote.version or (lib.getVersion remnote)" | tr -d '"')
    if [[ "$version" != "$currentVersion" ]]; then
      hash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url "$url")")
      update-source-version remnote "$version" "$hash" --print-changes
    fi
  '';

  meta = with lib; {
    description = "Note-taking application focused on learning and productivity";
    homepage = "https://remnote.com/";
    maintainers = with maintainers; [ chewblacka ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "remnote";
  };
}
