# Qingjian input method (Linux): offline dictionary and sentence model data.
#
# The data is an official GitHub Release asset (data-v3), versioned and hashed
# by the upstream tools/release/data.lock file. Since data-v3 the whole-sentence
# model is bundled inside the tarball (data/models/hanzhang-*) and model.qjm is
# no longer released separately. The archive's top-level directory is data/, so
# unpacking into share/qingjian/resources yields the layout expected by the
# server's resource_root().
{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  strictDeps = true;
  __structuredAttrs = true;
  pname = "qingjian-data";
  version = "3"; # upstream release tag data-v3

  src = fetchurl {
    url = "https://github.com/qingjian-team/qingjian/releases/download/data-v3/qingjian-data.tar.gz";
    sha256 = "42ad08fb2fe9f497c0ab191c120f05386f6adcc9d713c3283200aaed690e62f3";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/qingjian/resources
    tar -xzf $src -C $out/share/qingjian/resources
    # the store is read-only; relax so we can strip macOS AppleDouble files
    chmod -R u+w $out
    find $out -name '._*' -delete
    runHook postInstall
  '';

  meta = {
    description = "Offline dictionary and sentence model data for the Qingjian input method";
    homepage = "https://github.com/qingjian-team/qingjian";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.aozora-wings ];
    platforms = lib.platforms.linux;
  };
}
