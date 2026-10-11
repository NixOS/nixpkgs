{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libeconf";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "libeconf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FR0oLGF0q2WPsZtQK2KGVeqh2UaBiEYNd5pLfNq+zGc=";
  };

  # unsupported flags that we can just remove
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace meson.build \
      --replace-fail "'-ffat-lto-objects'," "" \
      --replace-fail "version_flag = ['-Wl,--version-script,@0@/@1@'.format(meson.current_source_dir(), mapfile)]" "version_flag = []"
  '';

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Enhanced config file parser, which merges config files placed in several locations into one";
    homepage = "https://github.com/openSUSE/libeconf";
    changelog = "https://github.com/openSUSE/libeconf/blob/${finalAttrs.src.tag}/NEWS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ grimmauld ];
    mainProgram = "econftool";
    platforms = lib.platforms.all;
    pkgConfigModules = [ "libeconf" ];
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "opensuse" finalAttrs.version;
  };
})
