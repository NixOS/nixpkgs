{ lib
, fetchFromGitHub
, buildNpmPackage
, php83
, nixosTests
, dataDir ? "/var/lib/firefly-iii"
}:

let
  pname = "firefly-iii";
  version = "6.1.13";
  phpPackage = php83;

  src = fetchFromGitHub {
    owner = "firefly-iii";
    repo = "firefly-iii";
    rev = "v${version}";
    hash = "sha256-85zI8uCyyoCflzxDkvba6FWa9B3kh179DJfQ2Um6MGM=";
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version src;
    npmDepsHash = "sha256-wuPUE6XuzzgKjpxZVgwh2wGut15M61WSBFG+YIZwOFM=";
    dontNpmBuild = true;
    installPhase = ''
      runHook preInstall
      npm run build
      cp -r ./public $out/
      runHook postInstall
    '';
  };
in

phpPackage.buildComposerProject (finalAttrs: {
  inherit pname src version;

  vendorHash = "sha256-CVGKyyLp5hjjpEulDNEYfljU4OgPBaFcYQQAUf6GeGs=";

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
