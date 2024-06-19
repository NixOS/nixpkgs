{ lib
, fetchFromGitHub
, buildNpmPackage
, php83
, nixosTests
, writeScript
, prefetch-npm-deps
, nix-update
, dataDir ? "/var/lib/firefly-iii"
}:

let
  pname = "firefly-iii";
  version = "6.1.17";
  phpPackage = php83;

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "firefly-iii";
    rev = "v${version}";
    hash = "sha256-KbTHbhv+8Lv5fk1Z8nxICySk6MK6Xc3TNATSIUnENa4=";
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version src;
    npmDepsHash = "sha256-Nlz+zsvUx9X70uofh8dWEvru8SAQzIh+XxGGOH5npyY=";
    dontNpmBuild = true;
    installPhase = ''
      runHook preInstall
      npm run prod --workspace=v1
      npm run build --workspace=v2
      cp -r ./public $out/
      runHook postInstall
    '';
  };
in

phpPackage.buildComposerProject (finalAttrs: {
  inherit pname src version;

  vendorHash = "sha256-mDVmZUCER1eaTXhh8VIbGbPkkpOeE6fTBhq8UnTlWPc=";

  passthru = {
    inherit phpPackage assets;
    tests = nixosTests.firefly-iii;
    updateScript = writeScript "update-firefly" ''
        NEW_VERSION=$(curl --silent https://api.github.com/repos/firefly-iii/firefly-iii/releases/latest | jq -r '.tag_name')
        OLD_HASH="$(nix --extra-experimental-features nix-command eval -f default.nix --raw firefly-iii.assets.npmDepsHash)"
        FILE="$(mktemp)"
        curl --silent https://raw.githubusercontent.com/firefly-iii/firefly-iii/$NEW_VERSION/package-lock.json > "$FILE"
        NEW_HASH=$(${lib.getExe prefetch-npm-deps} "$FILE")
        rm "$FILE"
        sed -e "s#$OLD_HASH#$NEW_HASH#" -i pkgs/by-name/fi/firefly-iii/package.nix
        ${lib.getExe nix-update} firefly-iii --version "$NEW_VERSION"
      '';
  };

  postInstall = ''
    mv $out/share/php/${pname}/* $out/
    rm -R $out/share $out/storage $out/bootstrap/cache $out/public
    cp -a ${assets} $out/public
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/cache $out/bootstrap/cache
  '';

  meta = {
    changelog = "https://github.com/firefly-iii/firefly-iii/releases/tag/v${version}";
    description = "Firefly III: a personal finances manager";
    homepage = "https://github.com/firefly-iii/firefly-iii";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.savyajha lib.maintainers.patrickdag ];
  };
})
