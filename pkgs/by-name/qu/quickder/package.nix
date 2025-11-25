{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  python3,
  cmake,
  doxygen,
  graphviz,
  quickmem,
  arpa2common,
  arpa2cm,
  ensureNewerSourcesForZipFilesHook,
}:

let
  python =
    let
      packageOverrides = self: super: {
        pyparsing = super.pyparsing.overridePythonAttrs (old: rec {
          version = "3.1.2";
          src = fetchFromGitHub {
            owner = "pyparsing";
            repo = "pyparsing";
            rev = "refs/tags/${version}";
            hash = "sha256-0B8DjO4kLgvt4sYsk8CZI+5icdKy73XE2tWeqVLqO5A=";
          };
        });
      };
    in
    python3.override {
      inherit packageOverrides;
      self = python;
    };
in
stdenv.mkDerivation rec {
  pname = "quickder";
  version = "1.7.1";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "quick-der";
    rev = "v${version}";
    hash = "sha256-f+ph5PL+uWRkswpOLDwZFWjh938wxoJ6xocJZ2WZLEk=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    ensureNewerSourcesForZipFilesHook
  ];

  buildInputs = [
    arpa2cm
    arpa2common
    (python.withPackages (
      ps: with ps; [
        asn1ate
        colored
        pyparsing
        setuptools
        six
      ]
    ))
    quickmem
  ];

  postPatch = ''
    substituteInPlace setup.py --replace 'pyparsing==' 'pyparsing>='
  '';

  doCheck = true;

  meta = with lib; {
    description = "Quick (and Easy) DER, a Library for parsing ASN.1";
    homepage = "https://gitlab.com/arpa2/quick-der/";
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
