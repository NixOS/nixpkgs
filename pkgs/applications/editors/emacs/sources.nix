{ lib
, fetchFromBitbucket
, fetchFromSavannah
}:

{
  emacs28 = import ./generic.nix {
    pname = "emacs";
    version = "28.2";
    variant = "mainline";
    src = fetchFromSavannah {
      repo = "emacs";
      rev = "28.2";
      hash = "sha256-4oSLcUDR0MOEt53QOiZSVU8kPJ67GwugmBxdX3F15Ag=";
    };
  };

  emacs29 = import ./generic.nix {
    pname = "emacs";
    version = "29.0.91";
    variant = "mainline";
    src = fetchFromSavannah {
      repo = "emacs";
      rev = "29.0.91";
      hash = "sha256-YU/sbIr7xX5ELJtPcTL9ZQgZtjEW5oI7YC20fQsOVSY=";
    };
  };

  emacs-macport = import ./generic.nix {
    pname = "emacs-mac";
    version = "28.2";
    variant = "macport";
    src = fetchFromBitbucket {
      owner = "mituharu";
      repo = "emacs-mac";
      rev = "emacs-28.2-mac-9.1";
      hash = "sha256-Ne2jQ2nVLNiQmnkkOXVc5AkLVkTpm8pFC7VNY2gQjPE=";
    };
  };
}
