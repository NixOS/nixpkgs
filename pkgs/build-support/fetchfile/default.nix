{stdenv}: {pathname, md5 ? "", sha256 ? ""}: stdenv.mkDerivation {
  name = baseNameOf (toString pathname);
  builder = ./builder.sh;
  pathname = pathname;
} // if (sha256 == "") then {
  md5 = (stdenv.lib.fetchMD5warn "fetchfile" pathname md5);
  id = md5;
} else {
  sha256 = sha256;
  id = sha256;
}
