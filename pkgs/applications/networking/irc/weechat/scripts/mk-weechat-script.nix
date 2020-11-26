{ stdenv, fetchFromGitHub }:

# This is a variant of mkDerivation to make derivations for the scripts on the
# Weechat Scripts site (https://weechat.org/scripts/). These scripts are stored
# in a Git repository at https://github.com/weechat/scripts. To build a script,
# this function downloads a particular revision of that repository and extracts
# a particular file. (All of the scripts on that site are interpreted, so no
# build phase is needed.)

# The name of the derivation to be produced.
{ pname
# The version of the derivation.
, version
# The filename (including extension) of the script.
, filename
# The subfolder within the Git repo in which this script can be found. This
# value can be inferred from the value of "filename"; it shouldn't be necessary
# to set it explicitly.
, subfolder ? if stdenv.lib.strings.hasSuffix ".scm" filename then "guile"
         else if stdenv.lib.strings.hasSuffix ".js"  filename then "javascript"
         else if stdenv.lib.strings.hasSuffix ".lua" filename then "lua"
         else if stdenv.lib.strings.hasSuffix ".pl"  filename then "perl"
         else if stdenv.lib.strings.hasSuffix ".py"  filename then "python"
         else if stdenv.lib.strings.hasSuffix ".tcl" filename then "tcl"
         else throw "The value of the \"filename\" attribute has an unrecognized suffix"
# The revision of the scripts repo.
, repoRev
# The checksum of this revision of the repo.
, repoSha256
# The usual derivation metadata (description, license, etc.).
, meta
} @ attrs:

stdenv.mkDerivation rec {
  inherit (pname version meta);

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "weechat";
    repo = "scripts";
    rev = repoRev;
    sha256 = repoSha256;
  };

  passthru.scripts = [ filename ];

  dontBuild = true;

  installPhase = ''
    install -D -m 0644 ${subfolder}/${filename} $out/share/${filename}
  '';
}
