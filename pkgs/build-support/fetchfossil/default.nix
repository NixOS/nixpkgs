{stdenv, fossil}:

{name ? null, url, rev ? null, md5 ? null, sha256 ? null}:

# TODO: statically check if mercurial as the https support if the url starts woth https.
stdenv.mkDerivation {
  name = "fossil-archive" + (if name != null then "-${name}" else "");
  builder = ./builder.sh;
  buildInputs = [fossil];

  impureEnvVars = [
    "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"
  ];

  outputHashAlgo = if md5 != null then "md5" else "sha256";
  outputHashMode = "recursive";
  outputHash = if md5 != null then md5 else sha256;

  inherit url rev;
  preferLocalBuild = true;
}
