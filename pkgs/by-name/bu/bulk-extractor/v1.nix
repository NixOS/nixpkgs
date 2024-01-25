{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook

, exiv2
, flex
, git
, json_c
, libewf
, libxml2
, openssl
, sqlite
, tre
, zlib

, withBEViewer ? true
, jdk
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bulk_extractor";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "simsong";
    repo = "bulk_extractor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-w09dEBoZ4nEdKgeDbEdwB2tBeblplxKWyHbKGcFsTtk=";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    exiv2
    flex
    git
    json_c
    libewf
    libxml2
    openssl
    sqlite
    tre
    zlib
  ]
  ++ lib.optionals withBEViewer [
    jdk
  ];

  postInstall = lib.optionalString withBEViewer ''
    substituteInPlace $out/bin/BEViewer \
      --replace 'java' "${jdk}/bin/java"
  '';

  inherit (import ./common.nix { inherit lib finalAttrs; }) meta;
})
