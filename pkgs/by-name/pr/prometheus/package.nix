{
  stdenv,
  lib,
  go,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
  enableAWS ? true,
  enableAzure ? true,
  enableConsul ? true,
  enableDigitalOcean ? true,
  enableDNS ? true,
  enableEureka ? true,
  enableGCE ? true,
  enableHetzner ? true,
  enableIONOS ? true,
  enableKubernetes ? true,
  enableLinode ? true,
  enableMarathon ? true,
  enableMoby ? true,
  enableNomad ? true,
  enableOpenstack ? true,
  enableOVHCloud ? true,
  enablePuppetDB ? true,
  enableScaleway ? true,
  enableTriton ? true,
  enableUyuni ? true,
  enableVultr ? true,
  enableXDS ? true,
  enableZookeeper ? true,
}:

let
  source = import ./source.nix;

  inherit (source) version vendorHash;

  pname = "prometheus";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "prometheus";
    tag = "v${version}";
    hash = source.hash;
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version;

    src = "${src}/web/ui";

    npmDepsHash = source.npmDepsHash;

    patches = [
      # Disable old React app as it depends on deprecated create-react-apps
      # script
      ./disable-react-app.diff
    ];

    doCheck = true;
    checkPhase = ''
      runHook preCheck
      CI=true npm test
      runHook postCheck
    '';

    postInstall = ''
      mkdir -p $out/static
      cp -r $out/lib/node_modules/prometheus-io/static/* $out/static
      find $out/static -type f -exec gzip -f9 {} \;

      # Remove node_modules
      rm -rf $out/lib
    '';
  };
in
buildGoModule (finalAttrs: {
  inherit
    pname
    version
    vendorHash
    src
    ;

  outputs = [
    "out"
    "doc"
    "cli"
  ];

  excludedPackages = [
    "documentation/prometheus-mixin"
    "internal/tools"
    "web/ui/mantine-ui/src/promql/tools"
  ];

  postPatch = ''
    cp -r ${assets}/static web/ui/static/

    patchShebangs scripts

    # Enable only select service discovery to shrink binaries.
    (
      true # prevent bash syntax error when all plugins are disabled
    ${lib.optionalString enableAWS "echo - github.com/prometheus/prometheus/discovery/aws"}
    ${lib.optionalString enableAzure "echo - github.com/prometheus/prometheus/discovery/azure"}
    ${lib.optionalString enableConsul "echo - github.com/prometheus/prometheus/discovery/consul"}
    ${lib.optionalString enableDigitalOcean "echo - github.com/prometheus/prometheus/discovery/digitalocean"}
    ${lib.optionalString enableDNS "echo - github.com/prometheus/prometheus/discovery/dns"}
    ${lib.optionalString enableEureka "echo - github.com/prometheus/prometheus/discovery/eureka"}
    ${lib.optionalString enableGCE "echo - github.com/prometheus/prometheus/discovery/gce"}
    ${lib.optionalString enableHetzner "echo - github.com/prometheus/prometheus/discovery/hetzner"}
    ${lib.optionalString enableIONOS "echo - github.com/prometheus/prometheus/discovery/ionos"}
    ${lib.optionalString enableKubernetes "echo - github.com/prometheus/prometheus/discovery/kubernetes"}
    ${lib.optionalString enableLinode "echo - github.com/prometheus/prometheus/discovery/linode"}
    ${lib.optionalString enableMarathon "echo - github.com/prometheus/prometheus/discovery/marathon"}
    ${lib.optionalString enableMoby "echo - github.com/prometheus/prometheus/discovery/moby"}
    ${lib.optionalString enableNomad "echo - github.com/prometheus/prometheus/discovery/nomad"}
    ${lib.optionalString enableOpenstack "echo - github.com/prometheus/prometheus/discovery/openstack"}
    ${lib.optionalString enableOVHCloud "echo - github.com/prometheus/prometheus/discovery/ovhcloud"}
    ${lib.optionalString enablePuppetDB "echo - github.com/prometheus/prometheus/discovery/puppetdb"}
    ${lib.optionalString enableScaleway "echo - github.com/prometheus/prometheus/discovery/scaleway"}
    ${lib.optionalString enableTriton "echo - github.com/prometheus/prometheus/discovery/triton"}
    ${lib.optionalString enableUyuni "echo - github.com/prometheus/prometheus/discovery/uyuni"}
    ${lib.optionalString enableVultr "echo - github.com/prometheus/prometheus/discovery/vultr"}
    ${lib.optionalString enableXDS "echo - github.com/prometheus/prometheus/discovery/xds"}
    ${lib.optionalString enableZookeeper "echo - github.com/prometheus/prometheus/discovery/zookeeper"}
    ) > plugins.yml
  '';

  preBuild = ''
    if [[ -d vendor ]]; then GOARCH= make -o assets plugins; fi

    # Recreate the `make assets-compress` target here - workaround permissions
    # errors
    cp web/ui/embed.go.tmpl web/ui/embed.go

    find web/ui/static -type f -name '*.gz' -print0 | sort -z | xargs -0 echo //go:embed >> web/ui/embed.go

    echo 'var EmbedFS embed.FS' >> web/ui/embed.go

    # EmbedFS requires relative paths
    substituteInPlace web/ui/embed.go --replace-fail "web/ui/" ""
  '';

  tags = [ "builtinassets" ];

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=${finalAttrs.version}"
      "-X ${t}.Revision=unknown"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
      "-X ${t}.GoVersion=${lib.getVersion go}"
    ];

  preInstall = ''
    mkdir -p "$out/share/doc/prometheus" "$out/etc/prometheus"
    cp -a $src/documentation/* $out/share/doc/prometheus
  '';

  postInstall = ''
    moveToOutput bin/promtool $cli
  '';

  # https://hydra.nixos.org/build/130673870/nixlog/1
  # Test mock data uses 64 bit data without an explicit (u)int64
  doCheck = !(stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.parsed.cpu.bits < 64);

  checkFlags = lib.optionals stdenv.hostPlatform.isAarch64 [
    "-skip=TestEvaluations/testdata/aggregators.test"
  ];

  passthru = {
    tests = { inherit (nixosTests) prometheus; };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Service monitoring system and time series database";
    homepage = "https://prometheus.io";
    license = licenses.asl20;
    maintainers = with maintainers; [
      fpletz
      Frostman
      jpds
    ];
  };
})
