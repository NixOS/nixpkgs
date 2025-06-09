{ fetchFromGitHub, openimageio }:

let
  version = "2.5.17.0";
in
openimageio.overrideAttrs {
  inherit version;

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenImageIO";
    tag = "v${version}";
    hash = "sha256-d5LqRcqWj6E9jJYY/Pa5e7/MeuQGMjUo/hMCYRKsKeU=";
  };
}
