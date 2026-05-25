{
  lib,
  fetchFromGitHub,
  nixosTests,
  brotli,
  not-ocamlfind,
  ocamlPackages,
}:

let
  inherit (ocamlPackages)
    buildDunePackage
    ancient
    benchmark
    calendars
    camlp-streams
    camlp5
    cmdliner
    cppo
    decompress
    digestif
    dune-site
    fmt
    jingoo
    logs
    logs-syslog
    markup
    ounit
    pcre2
    pp_loc
    ppx_blob
    ppx_deriving
    ppx_import
    ptime
    re
    stdlib-shims
    unidecode
    uri
    uucp
    uunf
    uutf
    yojson
    zarith
    ;

  version = "7.1.0-beta2-unstable-2026-05-20";
  src = fetchFromGitHub {
    owner = "geneweb";
    repo = "geneweb";
    rev = "3e660222f8083a12fc0da725a3ee46840e9d498f";
    hash = "sha256-jDWioFdKPasXyqBTOgMpAlbn3QdKiK8wdKuGZgXNG9k=";
  };

  commonMeta = {
    homepage = "https://geneweb.org";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ lib.maintainers.darkone ];
  };

  geneweb-compat = buildDunePackage {
    pname = "geneweb-compat";
    inherit src version;

    meta = commonMeta // {
      description = "Internal compatibility library for GeneWeb";
    };
  };

  geneweb-http = buildDunePackage {
    pname = "geneweb-http";
    inherit src version;

    buildInputs = [
      geneweb-compat
      camlp-streams
      logs
      fmt
    ];

    meta = commonMeta // {
      description = "Internal HTTP library for GeneWeb";
    };
  };

in
buildDunePackage {
  pname = "geneweb";
  inherit version src;

  __structuredAttrs = true;

  nativeBuildInputs = [
    brotli
    camlp5
    cppo
    not-ocamlfind
  ];

  buildInputs = [

    # Internal workspace libs
    geneweb-compat
    geneweb-http

    # External dependencies
    ancient
    benchmark
    calendars
    camlp-streams
    camlp5
    cmdliner
    decompress
    digestif
    dune-site
    fmt
    jingoo
    logs
    logs-syslog
    markup
    ounit
    pcre2
    pp_loc
    ppx_blob
    ppx_deriving
    ppx_import
    ptime
    re
    stdlib-shims
    unidecode
    uri
    uucp
    uunf
    uutf
    yojson
    zarith
  ];

  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) geneweb;
  };

  meta = commonMeta // {
    description = "Open source genealogy software with a web interface";
    longDescription = ''
      GeneWeb is an open source genealogy software written in OCaml.
      It comes with a Web interface and can be used off-line or as a Web service.
    '';
    mainProgram = "gwd";
  };
}
