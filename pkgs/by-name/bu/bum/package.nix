{
  autoreconfHook,
  fetchFromCodeberg,
  gitMinimal,
  git-extras,
  lib,
  makeWrapper,
  nix-update-script,
  reuse,
  stdenvNoCC,
  vim,
  vimPackage ? vim,
  zsh,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bum";
  version = "2.3";

  src = fetchFromCodeberg {
    owner = "waterkip";
    repo = "bum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/leDpCoZFNxFWCYUJ+Hy+l5EVs8Pxf57kRm7dkcxopc=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  configureFlags = [
    "re_zsh=1"
    "re_git=1"
  ];

  buildInputs = [
    zsh
  ];

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
  ];

  # Some upstream zsh scripts lack a shebang, so add one for patchShebangs
  postInstall = ''
    for file in $out/bin/*; do
      head -n1 "$file" | grep -q '^#!' || sed -i '1i #!/usr/bin/env zsh' "$file"
    done

    for file in $(find $out/bin/ -type f -perm /o+x); do
      wrapProgram $file \
        --prefix PATH : ${
          lib.makeBinPath [
            gitMinimal
            git-extras
            reuse
            vimPackage
          ]
        }
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://codeberg.org/waterkip/bum/src/tag/${finalAttrs.src.tag}/Changes";
    description = "Collection of scripts and aliases working with git";
    homepage = "https://codeberg.org/waterkip/bum";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.all;
  };
})
