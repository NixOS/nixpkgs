{
  lib,
  stdenvNoCC,
  git,
  cacert,
  nautilus,
}:

stdenvNoCC.mkDerivation (finalAttrs: {

  pname = "nautilus-typeahead";
  version = "46.1-1"; # labeled by the AUR package version
  rev = "f5f593bf36c41756a29d5112a10cf7ec70b8eafb";
  outputHash = "sha256-z+JX8z/NCrGeizghYfLMpoXCoSjnUzRKjM7vVA1J/zM=";

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
    git format-patch "${nautilus.version}".."${finalAttrs.rev}" --output="$out"

    set +x
  '';

  meta = {
    description = "AUR patch for the nautilus-typeahead package";
    homepage = "https://aur.archlinux.org/packages/nautilus-typeahead";
    changelog = "https://gitlab.gnome.org/albertvaka/nautilus/-/compare/${nautilus.version}...${finalAttrs.rev}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bryango ];
  };

})
