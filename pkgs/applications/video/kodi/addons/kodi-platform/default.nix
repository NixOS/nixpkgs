{
  stdenv,
  fetchFromGitHub,
  cmake,
  kodi,
  libcec_platform,
  tinyxml,
}:
stdenv.mkDerivation {
  pname = "kodi-platform";
  version = "17.1";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "kodi-platform";
    rev = "c8188d82678fec6b784597db69a68e74ff4986b5";
    sha256 = "1r3gs3c6zczmm66qcxh9mr306clwb3p7ykzb70r3jv5jqggiz199";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    kodi
    libcec_platform
    tinyxml
  ];
}
