{
  fetchurl,
  appimageTools,
  lib,
  makeWrapper,
  stdenv,
}:

let

  inherit (stdenv.hostPlatform) system;

  platform =
    {
      x86_64-linux = "amd64";
      aarch64-linux = "arm64";
    }
    .${system};

  # Get hash in sri format
  # nix-prefetch-url <url> | xargs nix hash to-sri --type sha256 --extra-experimental-features nix-command
  hash =
    {
      x86_64-linux = "sha256-Gj/VDsV+ks8bhsFwU47+oBmsYOa0lQMHZeqQ3/IHm9E=";
      aarch64-linux = "sha256-9pIT7iiarHBtHRdX5lqdfmJLJLMkugqZdprBZm5g1A8=";
    }
    .${system};

  pname = "buckets";
  version = "0.75.0";
  src = fetchurl {
    url = "https://github.com/buckets/application/releases/download/v${version}/Buckets-linux-latest-${platform}-${version}.AppImage";
    inherit hash;
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;
  name = pname;
  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ [ pkgs.libsodium ];
  extraInstallCommands = ''
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    for size in 16 32 48 64 128 256 512; do
        install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/''${size}x''${size}/apps/${pname}.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/${pname}.png
    done
  '';

  meta = {
    description = "Private family budgeting app";
    homepage = "https://www.budgetwithbuckets.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ kmogged ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "buckets";
    broken = !stdenv.hostPlatform.isLinux;
  };
}
