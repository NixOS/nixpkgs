# generic builder for Emacs packages

{ stdenv, fetchurl, emacs, texinfo
, extension ? (self : super : {})
}:

{ pname
, version
, src
, packageRequires ? []
, extraBuildInputs ? []

, files ? null
, fileSpecs ? [ "*.el" "*.el.in" "dir"
                "*.info" "*.texi" "*.texinfo"
                "doc/dir" "doc/*.info" "doc/*.texi" "doc/*.texinfo"
              ]

, meta ? {}

, preUnpack ? "", postUnpack ? ""
, patches ? [], patchPhase ? "", prePatch ? "", postPatch ? ""
, configureFlags ? [], preConfigure ? "", postConfigure ? ""
, buildPhase ? "", preBuild ? "", postBuild ? ""
, preInstall ? "", postInstall ? ""
, doCheck ? false, checkPhase ? "", preCheck ? "", postCheck ? ""
, preFixup ? "", postFixup ? ""
}:

let
  inherit (stdenv.lib) concatStringsSep optionalAttrs;

  packageBuild          = fetchurl {
    url = https://raw.githubusercontent.com/milkypostman/melpa/12a862e5c5c62ce627dab83d7cf2cca6e8b56c47/package-build.el;
    sha256 = "1nviyyprypz7nmam9rwli4yv3kxh170glfbznryrp4czxkrjjdhk";
  };

  fname = "${pname}-${version}";

  targets = concatStringsSep " " (if files == null then fileSpecs else files);

  defaultMeta = {
    broken = false;
    homepage = "http://melpa.org/#/${pname}";
    platforms = emacs.meta.platforms;
  };

in

stdenv.mkDerivation ({
  name = "emacs-${fname}";

  inherit src packageBuild;

  buildInputs = [emacs texinfo] ++ packageRequires ++ extraBuildInputs;
  propagatedBuildInputs = packageRequires;
  propagatedUserEnvPkgs = packageRequires;

  setupHook = ./setup-hook.sh;

  buildPhase = ''
    runHook preBuild

    emacs --batch -Q -l $packageBuild -l ${./melpa2nix.el} \
      -f melpa2nix-build-package \
      ${pname} ${version} ${targets}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    emacs --batch -Q -l $packageBuild -l ${./melpa2nix.el} \
      -f melpa2nix-install-package \
      ${fname}.* $out/share/emacs/site-lisp/elpa

    runHook postInstall
  '';

  meta = defaultMeta // meta;
}

// optionalAttrs (preUnpack != "")      { inherit preUnpack; }
// optionalAttrs (postUnpack != "")     { inherit postUnpack; }
// optionalAttrs (configureFlags != []) { inherit configureFlags; }
// optionalAttrs (patches != [])        { inherit patches; }
// optionalAttrs (patchPhase != "")     { inherit patchPhase; }
// optionalAttrs (prePatch != "")       { inherit prePatch; }
// optionalAttrs (postPatch != "")      { inherit postPatch; }
// optionalAttrs (preConfigure != "")   { inherit preConfigure; }
// optionalAttrs (postConfigure != "")  { inherit postConfigure; }
// optionalAttrs (buildPhase != "")     { inherit buildPhase; }
// optionalAttrs (preBuild != "")       { inherit preBuild; }
// optionalAttrs (postBuild != "")      { inherit postBuild; }
// optionalAttrs (doCheck)              { inherit doCheck; }
// optionalAttrs (checkPhase != "")     { inherit checkPhase; }
// optionalAttrs (preCheck != "")       { inherit preCheck; }
// optionalAttrs (postCheck != "")      { inherit postCheck; }
// optionalAttrs (preInstall != "")     { inherit preInstall; }
// optionalAttrs (postInstall != "")    { inherit postInstall; }
// optionalAttrs (preFixup != "")       { inherit preFixup; }
// optionalAttrs (postFixup != "")      { inherit postFixup; }
)
