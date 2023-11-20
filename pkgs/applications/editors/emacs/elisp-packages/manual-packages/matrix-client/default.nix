{ lib
, melpaBuild
, fetchFromGitHub
, fetchpatch
, writeText
# Emacs packages
, _map
, a
, anaphora
, cl-lib
, dash
, dash-functional
, esxml
, f
, frame-purpose
, ht
, ov
, rainbow-identifiers
, request
, s
, tracking
}:

let
  rev = "d2ac55293c96d4c95971ed8e2a3f6f354565c5ed";
in melpaBuild {
  pname = "matrix-client";
  version = "0.3.0";

  commit = rev;

  src = fetchFromGitHub {
    owner = "alphapapa";
    repo = "matrix-client.el";
    inherit rev;
    sha256 = "1scfv1502yg7x4bsl253cpr6plml1j4d437vci2ggs764sh3rcqq";
  };

  patches = [
    # Fix: avatar loading when imagemagick support is not available
    (fetchpatch {
      url = "https://github.com/alphapapa/matrix-client.el/commit/5f49e615c7cf2872f48882d3ee5c4a2bff117d07.patch";
      sha256 = "07bvid7s1nv1377p5n61q46yww3m1w6bw4vnd4iyayw3fby1lxbm";
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

  recipe = writeText "recipe" ''
    (matrix-client :repo "alphapapa/matrix-client.el" :fetcher github)
  '';

  meta = {
    description = "A chat client and API wrapper for Matrix.org";
    license = lib.licenses.gpl3Plus;
  };
}
