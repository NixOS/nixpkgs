{ lib
, emacs
, emacsPackages
, fetchgit
}:

emacsPackages.melpaBuild (finalAttrs: {
  pname = "opencode";
  version = "0.1.0";

  src = fetchgit {
    url = "https://codeberg.org/sczi/opencode.el";
    rev = "dad7f2c418018b991701255b79cfb3be842fdb0a";
    sha256 = "sha256-+eJlOF4Fpm+dp5tqT6V7ktURF4BgEcKQkCkXChUiaPo=";
  };


  packageRequires = with emacsPackages; [
    magit
    markdown-mode
    plz
    plz-media-type
    plz-event-source
  ];

  meta =  {
    description = "Emacs integration for OpenCode AI tooling";
    maintainers = with lib.maintainers; [ zstg ];
    license = lib.licenses.gpl3;
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
      "x86_64-windows"
    ];
  };
})
