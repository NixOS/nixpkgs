{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  alcotest,
  astring,
  capnp,
  capnproto,
  eio,
  fmt,
  logs,
  stdint,
  uri,
}:

buildDunePackage (finalAttrs: {
  pname = "capnp-rpc";
  version = "2.1.2-unstable-2026-09-13";

  minimalOCamlVersion = "5.2";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "capnp-rpc";
    rev = "256ad12f21931f04eb88ad4d5cc966b7829bd906";
    hash = "sha256-zibjsyp4Vin0sZrwWio+h/88bdsVfmFEA7aPmc1IRg0=";
  };

  nativeBuildInputs = [
    capnp
    capnproto
  ];

  propagatedBuildInputs = [
    astring
    capnp
    fmt
    logs
    eio
    stdint
    uri
  ];

  checkInputs = [
    alcotest
  ];

  doCheck = true;

  meta = {
    description = "Cap'n Proto RPC library for OCaml";
    homepage = "https://github.com/mirage/capnp-rpc";
    changelog = "https://github.com/mirage/capnp-rpc/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.asl20;
  };
})
