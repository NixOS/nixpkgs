{
  lib,
  stdenv,
  fetchurl,
  fixDarwinDylibNames,
  libsndfile,
  pkg-config,
  python311,
}:
let
  mkWafPackage =
    {
      pname,
      version,
      url,
      hash,
      buildInputs ? [ ],
      configureArgs ? "",
      meta ? { },
    }:
    stdenv.mkDerivation {
      inherit
        pname
        version
        buildInputs
        meta
        ;

      src = fetchurl {
        inherit url hash;
      };

      strictDeps = true;

      nativeBuildInputs = [
        fixDarwinDylibNames
        pkg-config
        python311
      ];

      postPatch = ''
        patchShebangs .
      '';

      configurePhase = ''
        runHook preConfigure
        python3 ./waf configure --prefix="$out" ${configureArgs}
        runHook postConfigure
      '';

      buildPhase = ''
        runHook preBuild
        python3 ./waf build -j"$NIX_BUILD_CORES"
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        python3 ./waf install
        runHook postInstall
      '';
    };
in
rec {
  lv2 = mkWafPackage {
    pname = "lv2";
    version = "1.18.2-g611759d";
    url = "https://ardour.org/files/deps/lv2-1.18.2-g611759d.tar.bz2";
    hash = "sha256-4PFSo9cxD3/BwjOixkazGdRhWoIe/im/dEkoPLN8cM4=";
    configureArgs = "--lv2dir=$out/lib/lv2 --no-plugins";
    meta = {
      description = "Ardour-pinned LV2 specification bundle";
      homepage = "https://ardour.org/";
      license = lib.licenses.mit;
      platforms = [ "aarch64-darwin" ];
    };
  };

  serd = mkWafPackage {
    pname = "serd";
    version = "0.30.11-g36f1cecc";
    url = "https://ardour.org/files/deps/serd-0.30.11-g36f1cecc.tar.bz2";
    hash = "sha256-dq/phRE1HDxQAQ2fFFz9HxC1SpVly3iJ8MpRWNqAZZg=";
    configureArgs = "--no-utils";
    meta = {
      description = "Ardour-pinned RDF syntax library";
      homepage = "https://ardour.org/";
      license = lib.licenses.isc;
      platforms = [ "aarch64-darwin" ];
    };
  };

  sord = mkWafPackage {
    pname = "sord";
    version = "0.16.9-gd2efdb2";
    url = "https://ardour.org/files/deps/sord-0.16.9-gd2efdb2.tar.bz2";
    hash = "sha256-QBaPwI87Rf4syXi/OisUYH3IvixZWYvKwVI8vlm5uho=";
    buildInputs = [ serd ];
    configureArgs = "--no-utils";
    meta = {
      description = "Ardour-pinned in-memory RDF store";
      homepage = "https://ardour.org/";
      license = [
        lib.licenses.bsd0
        lib.licenses.isc
      ];
      platforms = [ "aarch64-darwin" ];
    };
  };

  sratom = mkWafPackage {
    pname = "sratom";
    version = "0.6.8-gc46452c";
    url = "https://ardour.org/files/deps/sratom-0.6.8-gc46452c.tar.bz2";
    hash = "sha256-nKJYiJZNBi/pxzkOI/yw3iFdoPQzzgMujlcK2b13Ltk=";
    buildInputs = [
      lv2
      serd
      sord
    ];
    meta = {
      description = "Ardour-pinned LV2 atom serialisation library";
      homepage = "https://ardour.org/";
      license = lib.licenses.mit;
      platforms = [ "aarch64-darwin" ];
    };
  };

  lilv = mkWafPackage {
    pname = "lilv";
    version = "0.24.13-g71a2ff5";
    url = "https://ardour.org/files/deps/lilv-0.24.13-g71a2ff5.tar.bz2";
    hash = "sha256-/TBT90TQS71yr/hUlXb8EVSZ/YBtoPMtHuO572Wh53w=";
    buildInputs = [
      lv2
      serd
      sord
      sratom
      libsndfile
    ];
    configureArgs = "--no-utils --no-bindings";
    meta = {
      description = "Ardour-pinned LV2 host support library";
      homepage = "https://ardour.org/";
      license = lib.licenses.mit;
      platforms = [ "aarch64-darwin" ];
    };
  };
}
