{ lib, stdenv, emacs, fetchFromGitHub, fetchpatch, pkg-config, python3 }:

stdenv.mkDerivation {
  pname = "emacspy";
  version = "unstable-2023-03-04";

  src = fetchFromGitHub {
    owner = "zielmicha";
    repo = "emacspy";
    rev = "2cdb3bf7e25b4b0562b57df045a329b4ee694c3b";
    hash = "sha256-B4BP9hPywwqVfYCGnAqbM8ZVVgnua1E2tDk7X9aoUfQ=";
  };

  patches = [
    # Add floats and __eq__
    (fetchpatch {
      url = "https://github.com/zielmicha/emacspy/commit/ecbb069761d63315edf7ce2d871aded1629bffd9.patch";
      hash = "sha256-5OHj0RXUvofyo7kHjSY5foGfXwnuMCo7hXf5qoRAIHo=";
    })
    # Add __len__ and __iter__
    (fetchpatch {
      url = "https://github.com/zielmicha/emacspy/commit/80d06901c53ecc84bc3f26bd32bbe6fb54e2e5b0.patch";
      hash = "sha256-5Ux16ER2dpl//28Gt/KmYCIY1IsPpqjJNKCduI2xt1c=";
    })
    # Provide emacspy to Emacs
    (fetchpatch {
      url = "https://github.com/zielmicha/emacspy/commit/087049f49d95cba5252acf2bcf893f153123c8b5.patch";
      hash = "sha256-5Vwmwqm/MELym87Cc7XR+ff8qW97jgM+CUVWTrQ3OfQ=";
    })
    # Fix python pkg-config
    (fetchpatch {
      url = "https://github.com/zielmicha/emacspy/commit/6b5bf82a53f4e22f0af03d4f2562765dbf766ebb.patch";
      hash = "sha256-im+g/vhXgskdd0wxOlA8YC5VCAcSmizIyrUtrRDEHeM=";
    })
  ];

  preBuild = ''
    rm emacs-module.h
  '';

  nativeBuildInputs = [
    pkg-config
    python3.pkgs.cython
  ];

  buildInputs = [
    emacs
    python3
  ];

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/emacs/site-lisp/ emacspy.so

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/zielmicha/emacspy";
    description = "Program Emacs in Python instead of ELisp (i.e. write dynamic modules for Emacs in Python)";
    maintainers = [ lib.maintainers.marsam ];
    license = lib.licenses.mit;
    inherit (emacs.meta) platforms;
  };
}
