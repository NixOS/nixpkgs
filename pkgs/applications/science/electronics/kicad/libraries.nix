{ stdenv, lib, fetchFromGitHub, cmake, gettext
, with3d ? true
}:

with lib;
let
  version = "5.1.5";
  mkLib = version: name: sha256: attrs: stdenv.mkDerivation ({
    name = "kicad-${name}-${version}";
    src = fetchFromGitHub {
      owner = "KiCad";
      repo = "kicad-${name}";
      rev = version;
      inherit sha256 name;
    };
    nativeBuildInputs = [ cmake ];
  } // attrs);
in
{
  symbols = mkLib "${version}" "symbols" "048b07ffsaav1ssrchw2p870lvb4rsyb5vnniy670k7q9p16qq6h" {
    meta.license = licenses.cc-by-sa-40;
  };
  templates = mkLib "${version}" "templates" "0cs3bm3zb5ngw5ldn0lzw5bvqm4kvcidyrn76438alffwiz2b15g" {
    meta.license = licenses.cc-by-sa-40;
  };
  footprints = mkLib "${version}" "footprints" "1c4whgn14qhz4yqkl46w13p6rpv1k0hsc9s9h9368fxfcz9knb2j" {
    meta.license = licenses.cc-by-sa-40;
  };
  i18n = mkLib "${version}" "i18n" "1rfpifl8vky1gba2angizlb2n7mwmsiai3r6ip6qma60wdj8sbd3" {
    buildInputs = [ gettext ];
    meta.license = licenses.gpl2; # https://github.com/KiCad/kicad-i18n/issues/3
  };
  packages3d = mkLib "${version}" "packages3d" "0cff2ms1bsw530kqb1fr1m2pjixyxzwa81mxgac3qpbcf8fnpvaz" {
    hydraPlatforms = []; # this is a ~1 GiB download, occupies ~5 GiB in store
    meta.license = licenses.cc-by-sa-40;
  };
}
