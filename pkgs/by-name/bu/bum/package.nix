{
  autoreconfHook,
  bats,
  coreutils,
  fetchFromCodeberg,
  findutils,
  gawk,
  gitMinimal,
  gnugrep,
  gnused,
  lib,
  makeBinaryWrapper,
  nix-update-script,
  reuse,
  stdenvNoCC,
  universal-ctags,
  vim,
  writableTmpDirAsHomeHook,
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
    makeBinaryWrapper
  ];

  # Upstream runs the scripts without a shebang through sh, which splits the
  # upstreams list and an editor command with arguments, but zsh does not
  postPatch = ''
    substituteInPlace src/bin/git-set-master.zsh \
      --replace-fail 'for i in $BUM_UPSTREAMS' 'for i in ''${=BUM_UPSTREAMS}'
    substituteInPlace src/bin/git-editor.zsh \
      --replace-fail 'xargs -o -r ''${VISUAL' 'xargs -o -r ''${=VISUAL'
  '';

  # Some upstream zsh scripts lack a shebang, so add one for patchShebangs.
  # The scripts rely on GNU tools and on the -R and -L flags of
  # universal-ctags, which the BSD ctags of Darwin lacks, so those come first
  # in PATH.  The git that runs a subcommand puts itself first in PATH, so the
  # bundled git, vim and reuse are only fallbacks behind the user's own.
  postInstall = ''
    for file in $out/bin/*; do
      head -n1 "$file" | grep -q '^#!' || sed -i '1i #!/usr/bin/env zsh' "$file"
      wrapProgram "$file" \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            findutils
            gawk
            gnugrep
            gnused
            universal-ctags
          ]
        } \
        --suffix PATH : ${
          lib.makeBinPath [
            gitMinimal
            reuse
            vim
          ]
        }
    done
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    bats
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  installCheckPhase = ''
    runHook preInstallCheck

    sed -i "s|/usr/local|$out|g" t/*.bats t/init-bum.bash

    # Expects git to print its tracking message before the switch message
    rm t/0200-git-new-branch.bats

    git config --global init.defaultBranch master
    PATH=$out/bin:$PATH bats t

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://codeberg.org/waterkip/bum/src/tag/${finalAttrs.src.tag}/Changes";
    description = "Collection of scripts and aliases working with git";
    homepage = "https://codeberg.org/waterkip/bum";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.unix;
  };
})
