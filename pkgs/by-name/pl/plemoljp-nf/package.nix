{
  stdenvNoCC,
  fetchzip,
  plemoljp,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plemoljp-nf";

  # plemoljp's updateScript also updates this version.
  # nixpkgs-update: no auto update
  inherit (plemoljp) version;

  src = fetchzip {
    url = "https://github.com/yuru7/PlemolJP/releases/download/v${finalAttrs.version}/PlemolJP_NF_v${finalAttrs.version}.zip";
    hash = "sha256-m8zR9ySl88DnVzG4fKJtc9WjSLDMLU4YDX+KXhcP2WU=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = plemoljp.meta // {
    description = "Composite font of IBM Plex Mono, IBM Plex Sans JP and nerd-fonts";
  };
})
