{
  lib,
  rustPlatform,
  fetchgit,
  pkg-config,
  libxkbcommon,
  stdenv,
  wayland,
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

  buildInputs = [
    libxkbcommon
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wayland ];

  postInstall = ''
    install -Dm644 lisp/*.el \
      --target-directory="$out"/share/emacs/site-lisp
    ln -s "$out"/lib/libreka.so "$_"
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
    badPlatforms = lib.platforms.darwin;
  };
})
