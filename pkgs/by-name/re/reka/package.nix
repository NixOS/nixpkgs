{
  lib,
  rustPlatform,
  fetchgit,
  pkg-config,
  libxkbcommon,
  stdenvNoCC,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reka";
  version = "0-unstable-2026-04-19";
  __structuredAttrs = true;

  src = fetchgit {
    url = "https://code.tvl.fyi/depot.git:/tools/emacs-pkgs/reka.git";
    rev = "90e89c2f51240e3d0a10d98e0cc61732bd86334e";
    sha256 = "sha256-w25BZpbKMAACFweRqNEtGDvw/sNNJUfsVJQCXh41Y6w=";
  };

  cargoHash = "sha256-h5FTiU6zR0+w0KVnrjjaeQkSXOuCrQOXbZinJMLrNiY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxkbcommon
  ]
  ++ lib.optionals stdenvNoCC.isLinux [ wayland ];

  postInstall = ''
    install -Dm644 lisp/*.el \
      --target-directory="$out"/share/emacs/site-lisp
    ln -s "$out"/lib/libreka.so "$_"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Emacs-based window manager for river";
    homepage = "https://code.tvl.fyi/about/tools/emacs-pkgs/reka";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    badPlatforms = lib.platforms.darwin;
  };
})
