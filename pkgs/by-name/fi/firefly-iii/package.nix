{ lib
, fetchFromGitHub
, buildNpmPackage
, php83
, nixosTests
, dataDir ? "/var/lib/firefly-iii"
}:

let
  pname = "firefly-iii";
  version = "6.1.16";
  phpPackage = php83;

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "firefly-iii";
    rev = "v${version}";
    hash = "sha256-1I4Wm10mmloqeWcpc4XloNATpvroiw6m8MiSVsoB6xo=";
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version src;
    npmDepsHash = "sha256-Ff7pDKoXvyj/gR+ljQsCjtyzxzJ7/zN6hRMEAderqOg=";
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

  vendorHash = "sha256-BanSEqE3KN46VtEZH0TVWUBrgPCwmd2TjheYq+e+lzo=";

  passthru = {
    inherit phpPackage;
    tests = nixosTests.firefly-iii;
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
    maintainers = [ lib.maintainers.savyajha ];
  };
})
