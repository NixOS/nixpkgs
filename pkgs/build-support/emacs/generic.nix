# generic builder for Emacs packages

{ lib, stdenv, emacs, texinfo }:

with lib;

{ pname
, version ? null

, buildInputs ? []
, packageRequires ? []

, meta ? {}

, ...
}@args:

let

  defaultMeta = {
    broken = false;
    platforms = emacs.meta.platforms;
  } // optionalAttrs ((args.src.meta.homepage or "") != "") {
    homepage = args.src.meta.homepage;
  };

in

stdenv.mkDerivation ({
  name = "emacs-${pname}${optionalString (version != null) "-${version}"}";

  buildInputs = [emacs texinfo] ++ packageRequires ++ buildInputs;
  propagatedBuildInputs = packageRequires;
  propagatedUserEnvPkgs = packageRequires;

  setupHook = ./setup-hook.sh;

  doCheck = false;

  meta = defaultMeta // meta;
}

// removeAttrs args [ "buildInputs" "packageRequires"
                      "meta"
                    ])
