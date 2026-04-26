{
  lib,
  stdenvNoCC,
  runCommand,
  fetchurl,
  curl,
  cacert,
  oath-toolkit,
  _7zz,
  love,
  luajit,
  makeWrapper,
  desktopToDarwinBundle,
  demoSrc ? false,
}:

let
  stdenv = stdenvNoCC;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "chains";
  version = "1.6.3";

  src =
    if demoSrc then
      fetchurl {
        url = "https://web.archive.org/web/20260325231350/https://2dengine.com/files/chains/chains-demo.appimage";
        hash = "sha256-tFEQFdL+249LPEcJEUSxJ8FWmHzBo9hHMZUrxVcSRuU=";
      }
    else
      runCommand "fetch-chains"
        {
          name = "chains.appimage";
          nativeBuildInputs = [
            curl
            cacert
            oath-toolkit
          ];
          impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
            "NIX_2DENGINE_USERNAME"
            "NIX_2DENGINE_PASSWORD"
            "NIX_2DENGINE_AUTHENTICATOR_KEY"
          ];
          outputHashAlgo = "sha256";
          outputHashMode = "flat";
          outputHash = "sha256-gyDQMfwpZ5KF4LMnkpbiZ64aHLeKRszu6rIklXiPDHM=";
        }
        ''
          if [[ -z "$NIX_2DENGINE_USERNAME" || -z "$NIX_2DENGINE_PASSWORD" || -z "$NIX_2DENGINE_AUTHENTICATOR_KEY" ]]; then
            echo "" >&2
            echo "***" >&2
            echo "To authenticate on 2denging.com, set the following environment variables" >&2
            echo "for the Nix builder process (nix-daemon in the multiuser case):" >&2
            echo "NIX_2DENGINE_USERNAME, NIX_2DENGINE_PASSWORD, and NIX_2DENGINE_AUTHENTICATOR_KEY." >&2
            echo "Alternatively, download the game manually on ${finalAttrs.meta.downloadPage}," >&2
            echo "and then add the downloaded file to the Nix store using" >&2
            echo "nix-store --add-fixed sha256 ${finalAttrs.src.name}" >&2
            echo "Alternatively, build `chains.override { demoSrc = true; }` instead." >&2
            echo "***" >&2
            echo "" >&2
            exit 1
          fi

          cookie_jar=$(mktemp)
          curl -s -X POST "https://2dengine.com/signin/$NIX_2DENGINE_USERNAME" \
            -d "username=$NIX_2DENGINE_USERNAME" \
            -d "password=$NIX_2DENGINE_PASSWORD" \
            -d "otp=$(oathtool --totp -b "$NIX_2DENGINE_AUTHENTICATOR_KEY")" \
            -c "$cookie_jar" \
            -o /dev/null
          curl -L -b "$cookie_jar" "https://2dengine.com/files/chains/chains.appimage" -o "$out"
          rm "$cookie_jar"
        '';

  nativeBuildInputs = [
    _7zz
    makeWrapper
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  unpackCmd = ''
    7zz x $curSrc -osource
    7zz x source/usr/bin/chains -osource/chains.love.dir
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -ar usr/share/{applications,icons} $out/share
    rm -r $out/share/icons/hicolor/scalable # application-x-love-game.svg
    cp -ar chains.love.dir $out/share/chains
    makeWrapper ${lib.getExe (love.override { inherit luajit; })} $out/bin/chains \
      --add-flags $out/share/chains \
      --add-flags --fused \
      --prefix LUA_CPATH ';' "${luajit.pkgs.getLuaCPath luajit.pkgs.lua-https}"

    runHook postInstall
  '';

  meta = {
    description = "Puzzle game with a unique feel and distinctive vector graphics style";
    homepage = "https://2dengine.com/game/chains";
    downloadPage = "https://2dengine.com/game/chains";
    changelog = "https://2dengine.com/notices/chains";
    platforms = love.meta.platforms;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "chains";
  };
})
