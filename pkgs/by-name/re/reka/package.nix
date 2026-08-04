{
  lib,
  rustPlatform,
  fetchgit,
  pkg-config,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reka";
  version = "0-unstable-2026-08-16";
  __structuredAttrs = true;

  src = fetchgit {
    url = "https://code.tvl.fyi/depot.git:/tools/emacs-pkgs/reka.git";
    rev = "07de418fedd226b3a807c9ed0fb06eda9f697e0c";
    hash = "sha256-jdggakCHHRNpRQUjpHHHWyBsU1SL61QIWZMV6A0IWfU=";
  };

  cargoHash = "sha256-h5FTiU6zR0+w0KVnrjjaeQkSXOuCrQOXbZinJMLrNiY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libxkbcommon ];

  # Move the module instead of symlinking it, because the fixup phase makes
  # symlinks relative and emacs.pkgs.withPackages copies them verbatim with
  # lndir, which leaves a dangling link when the wrapper does not link lib.
  postInstall = ''
    install -Dm644 lisp/*.el \
      --target-directory="$out"/share/emacs/site-lisp
    mv "$out"/lib/libreka.so "$out"/share/emacs/site-lisp
    rmdir "$out"/lib
  '';

  passthru.updateScript = nix-update-script {
    # The TVL josh proxy cannot be queried for new commits, so use the
    # official Codeberg mirror, which carries the same commits.
    extraArgs = [
      "--version=branch"
      "--url"
      "https://codeberg.org/tazjin/reka"
    ];
  };

  meta = {
    description = "Emacs-based window manager for river";
    homepage = "https://code.tvl.fyi/about/tools/emacs-pkgs/reka";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.linux;
  };
})
