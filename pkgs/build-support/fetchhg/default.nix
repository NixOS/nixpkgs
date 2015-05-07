{stdenv, mercurial, nix}: {name ? null, url, rev ? null, md5 ? null, sha256 ? null, fetchSubrepos ? false}:

# TODO: statically check if mercurial as the https support if the url starts woth https.
stdenv.mkDerivation {
  name = "hg-archive" + (if name != null then "-${name}" else "");
  builder = ./builder.sh;
  buildInputs = [mercurial];

  impureEnvVars = [
    "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"
  ];

  # Nix <= 0.7 compatibility.
  id = md5;

  subrepoClause = if fetchSubrepos then "S" else "";

  outputHashAlgo = if md5 != null then "md5" else "sha256";
  outputHashMode = "recursive";
  outputHash = if md5 != null then md5 else sha256;

  inherit url rev;
  preferLocalBuild = true;
}
