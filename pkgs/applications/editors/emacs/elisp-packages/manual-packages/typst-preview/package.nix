{
  lib,
  melpaBuild,
  websocket,
  f,
  fetchFromGitHub,
}:
melpaBuild {
  pname = "typst-preview";
  version = "0-unstable-2025-10-13";
  src = fetchFromGitHub {
    owner = "havarddj";
    repo = "typst-preview.el";
    rev = "74244aef2545d7bb79b5396dc6503e23e6d239a7";
    hash = "sha256-Bt2YvUpHx5vR+NwUVfk21h0BrLbuW182E0qqx1DNIOo=";
  };

  packageRequires = [
    websocket
    f
  ];

  meta = {
    description = "Typst live preview minor mode for Emacs";
    homepage = "https://github.com/havarddj/typst-preview.el";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sunworms ];
  };
}
