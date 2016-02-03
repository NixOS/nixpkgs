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

  unpackCmd = ''
    case "$curSrc" in
      *.el)
        # keep original source filename without the hash
        local filename=$(basename "$curSrc")
        filename="''${filename:33}"
        cp $curSrc $filename
        chmod +w $filename
        sourceRoot="."
        ;;
      *)
        _defaultUnpack "$curSrc"
        ;;
    esac
  '';

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
