{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "json2kdl";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "AgathaSorceress";
    repo = pname;
    rev = "ddef0dfe54db1dfbc96081b15ee6dd6ef2a807d3";
    hash = "sha256-zQCC5v2WmBAgso6IbLE2qgIzOdeUBxAElEvfYGjoC9M=";
  };

  cargoHash = "sha256-jDdVSCtRp6heE72+bxF6ixaYNbJpKkCDg4mQskbQoZc=";

  meta = {
    description = "A program that converts JSON files to KDL";
    homepage = "https://github.com/AgathaSorceress/json2kdl";
    platforms = lib.platforms.all;
    maintainers = (with lib.maintainers; [ feathecutie ]);
  };
}
