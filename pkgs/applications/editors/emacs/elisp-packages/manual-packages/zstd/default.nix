{
  lib,
  melpaBuild,
  stdenv,
  fetchFromGitHub,
  zstd,
}:

let
  libExt = stdenv.hostPlatform.extensions.sharedLibrary;
in
melpaBuild {
  pname = "zstd";
  version = "0-unstable-2020-06-03";

  src = fetchFromGitHub {
    owner = "syohex";
    repo = "emacs-zstd";
    rev = "072b264e2cbd5c05be06a1208ebccc2dab44be39";
    hash = "sha256-p8bxefytTOSV6vIG8PAPBXfVKA2rfmWdRtVwjE42mAw=";
  };

  buildInputs = [ zstd ];

  preBuild = ''
    $CC -std=gnu99 -shared -o zstd-core${libExt} zstd-core.c -lzstd
  '';

  files = ''(:defaults "zstd-core${libExt}")'';

  meta = {
    homepage = "https://github.com/syohex/emacs-zstd";
    description = "Zstd binding for Emacs Lisp";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ nagy ];
  };
}
