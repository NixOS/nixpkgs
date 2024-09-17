{
  lib,
  stdenvNoCC,
  git,
  cacert,
}:

stdenvNoCC.mkDerivation (finalAttrs: {

  pname = "nautilus-typeahead";
  pkgver = "46.1"; # base nautilus version for the AUR patch, not necessary the same as nixpkgs `nautilus.version`
  pkgrel = "1"; # revision number for the AUR package
  version = "${finalAttrs.pkgver}-${finalAttrs.pkgrel}";
  rev = "f5f593bf36c41756a29d5112a10cf7ec70b8eafb";
  outputHash = "sha256-bOPW7wRbEk+GMg29AKEGdlTyiYXg3r/tzTTYBkkK1r8=";

  name = "${finalAttrs.pname}-${finalAttrs.version}.patch";

  nativeBuildInputs = [ git ];
  env.GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  buildCommand = ''
    set -x

    git clone --filter=blob:none --single-branch \
      https://gitlab.gnome.org/albertvaka/nautilus.git

    cd nautilus
    git fetch origin "${finalAttrs.rev}"
    git remote add upstream \
      https://gitlab.gnome.org/GNOME/nautilus.git

    git fetch --filter=blob:none --tags upstream
    git format-patch "${finalAttrs.pkgver}".."${finalAttrs.rev}" --no-signature --output="$out"

    set +x
  '';

  meta = {
    description = "AUR patch for the nautilus-typeahead package";
    homepage = "https://aur.archlinux.org/packages/nautilus-typeahead";
    changelog = "https://gitlab.gnome.org/albertvaka/nautilus/-/compare/${finalAttrs.pkgver}...${finalAttrs.rev}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bryango ];
  };

})
