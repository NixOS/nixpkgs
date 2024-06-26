{
  lib,
  melpaBuild,
  fetchFromGitHub,
  writeText,
}:

let
  rev = "d8d168148c187ed19350bb7a1a190217c2915a63";
in
melpaBuild {
  pname = "haskell-unicode-input-method";
  version = "20110905.2307";

  commit = rev;

  src = fetchFromGitHub {
    owner = "roelvandijk";
    repo = "emacs-haskell-unicode-input-method";
    inherit rev;
    sha256 = "09b7bg2s9aa4s8f2kdqs4xps3jxkq5wsvbi87ih8b6id38blhf78";
  };

  recipe = writeText "recipe" ''
    (haskell-unicode-input-method
     :repo "roelvandijk/emacs-haskell-unicode-input-method"
     :fetcher github)
  '';

  packageRequires = [ ];

  meta = {
    homepage = "https://melpa.org/#haskell-unicode-input-method/";
    license = lib.licenses.free;
  };
}
