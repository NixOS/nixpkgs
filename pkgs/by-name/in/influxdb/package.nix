{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  rustPlatform,
  libiconv,
  nixosTests,
}:

let
  libflux_version = "0.200.0";

  # This is copied from influxdb2 with the required flux version
  flux = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "libflux";
    version = libflux_version;
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "flux";
      tag = "v${libflux_version}";
      hash = "sha256-naQKGSYt+zI8N8ydFo0PBNUFnlkieW0Drz/VVeHlL0Q=";
    };

    # the `strict` feature, which is enabled by default, makes warnings fatal.
    # this often causes build failures when new compiler versions are released.
    buildNoDefaultFeatures = true;
    buildFeatures = [ "cffi" ];
    sourceRoot = "${finalAttrs.src.name}/libflux";

    cargoHash = "sha256-E5A8PMblOIvZBWKcA+LkRmlSp8JR0pZy0bYMj7hftTg=";
    nativeBuildInputs = [ rustPlatform.bindgenHook ];
    buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;
    pkgcfg = ''
      Name: flux
      Version: ${libflux_version}
      Description: Library for the InfluxData Flux engine
      Cflags: -I/out/include
      Libs: -L/out/lib -lflux -lpthread
    '';
    postInstall = ''
      mkdir -p $out/include $out/pkgconfig
      cp -r $NIX_BUILD_TOP/source/libflux/include/influxdata $out/include
      printf "%s" "$pkgcfg" > $out/pkgconfig/flux.pc
      substituteInPlace $out/pkgconfig/flux.pc \
        --replace-fail /out $out
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install_name_tool -id $out/lib/libflux.dylib $out/lib/libflux.dylib
    '';

    __structuredAttrs = true;
  });
in
buildGoModule (finalAttrs: {
  pname = "influxdb";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RphVmI1bS5QSA+pgPanjoCS1/VpGJG1MpsPq1eh9Bb4=";
  };

  vendorHash = "sha256-a+yrF1dqMZAqRNq1Moj+zz9kIMPIHr2i4pgWnsbmwMw=";

  nativeBuildInputs = [ pkg-config ];

  env.PKG_CONFIG_PATH = "${flux}/pkgconfig";

  # Check that libflux is at the right version
  preBuild = ''
    flux_ver=$(grep github.com/influxdata/flux go.mod | awk '{print $2}')
    if [ "$flux_ver" != "v${libflux_version}" ]; then
      echo "go.mod wants libflux $flux_ver, but nix derivation provides ${libflux_version}"
      exit 1
    fi
  '';

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  excludedPackages = "test";

  passthru.tests = {
    inherit (nixosTests) influxdb;
  };

  meta = {
    description = "Open-source distributed time series database";
    license = lib.licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with lib.maintainers; [
      zimbatm
    ];
  };
})
