{
  lib,
  melpaBuild,
  fetchFromGitHub,
  fetchpatch,
  # Emacs packages
  _map,
  a,
  anaphora,
  cl-lib,
  dash,
  dash-functional,
  esxml,
  f,
  frame-purpose,
  ht,
  ov,
  rainbow-identifiers,
  request,
  s,
  tracking,
}:

melpaBuild {
  pname = "matrix-client";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "alphapapa";
    repo = "matrix-client.el";
    rev = "d2ac55293c96d4c95971ed8e2a3f6f354565c5ed";
    hash = "sha256-GLM8oCbm6PdEZPsM0ogMtNJr8mWjCKoX6ed5AUrYjuk=";
  };

  patches = [
    # Fix: avatar loading when imagemagick support is not available
    (fetchpatch {
      url = "https://github.com/alphapapa/matrix-client.el/commit/5f49e615c7cf2872f48882d3ee5c4a2bff117d07.patch";
      hash = "sha256-dXUa/HKDe+UjaXYTvgwPdXDuDcHB2HLPGWHboE+Lex0=";
    })
  ];

  packageRequires = [
    _map
    a
    anaphora
    cl-lib
    dash
    dash-functional
    esxml
    f
    frame-purpose
    ht
    ov
    rainbow-identifiers
    request
    s
    tracking
  ];

  meta = {
    description = "Chat client and API wrapper for Matrix.org";
    license = lib.licenses.gpl3Plus;
  };
}
