{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  libnxml,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmrss";
  version = "0.19.4";

  src = fetchFromGitHub {
    owner = "bakulf";
    repo = "libmrss";
    tag = finalAttrs.version;
    hash = "sha256-sllY0Q8Ct7XJn4A3N8xQCUqaHXubPoB49gBZS1vURBs=";
  };

  postPatch = ''
    touch NEWS # https://github.com/bakulf/libmrss/issues/3
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    curl
    libnxml
  ];

  meta = with lib; {
    homepage = "https://github.com/bakulf/libmrss";
    description = "C library for parsing, writing and creating RSS/ATOM files or streams";
    license = licenses.lgpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ sigmanificient ];
  };
})
