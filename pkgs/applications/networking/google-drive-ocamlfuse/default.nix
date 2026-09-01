{
  lib,
  ocaml,
  buildDunePackage,
  fetchFromGitHub,
  extlib,
  fuse3,
  gapi-ocaml,
  sqlite3,
  otoml,
  tiny_httpd,
  ounit2,
}:

buildDunePackage (finalAttrs: {
  pname = "google-drive-ocamlfuse";
  version = "0.9.0";

  minimalOCamlVersion = "4.13";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "google-drive-ocamlfuse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nTZdE9F6ufQ/O/Ck6fzoK65uZ0ylMR6HkwKsBNRDjMs=";
  };

  doCheck = lib.versionAtLeast ocaml.version "4.14";
  checkInputs = [ ounit2 ];

  buildInputs = [
    extlib
    fuse3
    gapi-ocaml
    sqlite3
    otoml
    tiny_httpd
  ];

  meta = {
    homepage = "https://github.com/astrada/google-drive-ocamlfuse/";
    description = "FUSE-based file system backed by Google Drive, written in OCaml";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ obadz ];
    mainProgram = "google-drive-ocamlfuse";
  };
})
