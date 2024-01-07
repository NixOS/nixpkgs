{ lib
, melpaBuild
, fetchFromGitHub
, consult
, embark
, forge
, markdown-mode
, writeText
}:

let
  argset = {
    pname = "consult-gh";
    ename = "consult-gh";
    version = "20231206.1823";

    src = fetchFromGitHub {
      owner = "armindarvish";
      repo = "consult-gh";
      rev = "a035eac54a3be270168e86f32075e5f6f426c103";
      hash = "sha256-qZ7ra8Q8kcBDfR832rquKn8fy0UrNhonHZcX1oCz3dI=";
    };

    commit = argset.src.rev;

    packageRequires = [
      consult
      embark
      forge
      markdown-mode
    ];

    recipe = writeText "recipe" ''
      (consult-gh
       :repo "armindarvish/consult-gh"
       :fetcher github)
    '';

    meta = {
      homepage = "https://github.com/armindarvish/consult-gh";
      description = "A GitHub CLI client inside GNU Emacs using Consult";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ AndersonTorres ];
    };
  };
in
melpaBuild argset
