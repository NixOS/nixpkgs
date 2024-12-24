# This combines together OCF definitions from other derivations.
# https://github.com/ClusterLabs/resource-agents/blob/master/doc/dev-guides/ra-dev-guide.asc
{
  stdenv,
  lib,
  runCommand,
  lndir,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  python3,
  glib,
  drbd,
  pacemaker,
}:

let
  drbdForOCF = drbd.override {
    forOCF = true;
  };
  pacemakerForOCF = pacemaker.override {
    forOCF = true;
  };

  resource-agentsForOCF = stdenv.mkDerivation rec {
    pname = "resource-agents";
    version = "4.10.0";

    src = fetchFromGitHub {
      owner = "ClusterLabs";
      repo = pname;
      rev = "v${version}";
      sha256 = "0haryi3yrszdfpqnkfnppxj1yiy6ipah6m80snvayc7v0ss0wnir";
    };

    patches = [
      # autoconf-2.72 upstream fix:
      #   https://github.com/ClusterLabs/resource-agents/pull/1908
      (fetchpatch {
        name = "autoconf-2.72.patch";
        url = "https://github.com/ClusterLabs/resource-agents/commit/bac658711a61fd704e792e2a0a45a2137213c442.patch";
        hash = "sha256-Xq7W8pMRmFZmkqb2430bY5zdmVTrUrob6GwGiN6/bKY=";
      })
    ];

    nativeBuildInputs = [
      autoreconfHook
      pkg-config
    ];

    buildInputs = [
      glib
      python3
    ];

    env.NIX_CFLAGS_COMPILE = toString (
      lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "12") [
        # Needed with GCC 12 but breaks on darwin (with clang) or older gcc
        "-Wno-error=maybe-uninitialized"
      ]
    );

    meta = with lib; {
      homepage = "https://github.com/ClusterLabs/resource-agents";
      description = "Combined repository of OCF agents from the RHCS and Linux-HA projects";
      license = licenses.gpl2Plus;
      platforms = platforms.linux;
      maintainers = with maintainers; [
        ryantm
        astro
      ];
    };
  };

in

# This combines together OCF definitions from other derivations.
# https://github.com/ClusterLabs/resource-agents/blob/master/doc/dev-guides/ra-dev-guide.asc
runCommand "ocf-resource-agents"
  {
    # Fix derivation location so things like
    #   $ nix edit -f. ocf-resource-agents
    # just work.
    pos = builtins.unsafeGetAttrPos "version" resource-agentsForOCF;

    # Useful to build and undate inputs individually:
    passthru.inputs = {
      inherit resource-agentsForOCF drbdForOCF pacemakerForOCF;
    };
  }
  ''
    mkdir -p $out/usr/lib/ocf
    ${lndir}/bin/lndir -silent "${resource-agentsForOCF}/lib/ocf/" $out/usr/lib/ocf
    ${lndir}/bin/lndir -silent "${drbdForOCF}/usr/lib/ocf/" $out/usr/lib/ocf
    ${lndir}/bin/lndir -silent "${pacemakerForOCF}/usr/lib/ocf/" $out/usr/lib/ocf
  ''
