{stdenv, fossil}:

{name ? null, url, rev, md5 ? null, sha256 ? null}:

stdenv.mkDerivation {
  name = "fossil-archive" + (if name != null then "-${name}" else "");
  builder = ./builder.sh;
  buildInputs = [fossil];

  # Envvar docs are hard to find. A link for the future:
  # https://www.fossil-scm.org/index.html/doc/trunk/www/env-opts.md
  impureEnvVars = [ "http_proxy" ];

  outputHashAlgo = if md5 != null then "md5" else "sha256";
  outputHashMode = "recursive";
  outputHash = if md5 != null then md5 else sha256;

  inherit url rev;
  preferLocalBuild = true;
}
