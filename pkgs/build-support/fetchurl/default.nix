# Argh, this thing is duplicated (more-or-less) in Nix (in corepkgs).
# Need to find a way to combine them.

{stdenv, curl}: # Note that `curl' may be `null', in case of the native stdenv.

{url, outputHash ? "", outputHashAlgo ? "", md5 ? "", sha1 ? "", sha256 ? ""}:

assert (outputHash != "" && outputHashAlgo != "")
    || md5 != "" || sha1 != "" || sha256 != "";

stdenv.mkDerivation {
  name = baseNameOf (toString url);
  builder = ./builder.sh;
  buildInputs = [curl];

  # Compatibility with Nix <= 0.7.
  id = md5;

  # New-style output content requirements.
  outputHashAlgo = if outputHashAlgo != "" then outputHashAlgo else
      if sha256 != "" then "sha256" else if sha1 != "" then "sha1" else "md5";
  outputHash = if outputHash != "" then outputHash else
      if sha256 != "" then sha256 else if sha1 != "" then sha1 else md5;
  
  inherit url;
}
