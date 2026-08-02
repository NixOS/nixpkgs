{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bash,
  scdoc,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fetchutils";
  version = "0.1.0-unstable-2025-06-23";

  src = fetchFromGitHub {
    owner = "kiedtl";
    repo = "fetchutils";
    rev = "462bf40a9b4121bb56b78bc8782a5d67ffefd0a2";
    hash = "sha256-reJXgEyoMRk+SEcwMXuW5BDB83PqgAbbAsugwYBHwC8=";
  };

  nativeBuildInputs = [
    scdoc
  ];

  buildInputs = [
    bash
  ];

  installFlags = [ "PREFIX=$(out)/" ];

  postPatch = ''
    patchShebangs --host src/*
  '';

  meta = {
    description = "Collection of small shell utilities to fetch system information";
    homepage = "https://github.com/kiedtl/fetchutils";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ moni ];
  };
})
