{
  lib,
  stdenv,
  fetchFromGitHub,
  fish,
  runtimeShell,
  replaceVars,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oh-my-fish";
  version = "8";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "oh-my-fish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2IDXRQUMuPHKHYsB+2kNWBc2WxgA6732oJbrPDjRdp0=";
  };

  patches = [
    ./001-writable-omf-path.diff
  ];

  buildInputs = [
    fish
  ];

  strictDeps = true;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/bin $out/share/oh-my-fish
    cp -vr * $out/share/oh-my-fish

    cp -v ${
      replaceVars ./omf-install {
        inherit fish runtimeShell;
        # replaced below
        omf = null;
      }
    } $out/bin/omf-install

    substituteInPlace $out/bin/omf-install \
      --replace-fail '@omf@' "$out"

    chmod +x $out/bin/omf-install
    cat $out/bin/omf-install

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/oh-my-fish/oh-my-fish";
    description = "Fish Shell Framework";
    longDescription = ''
      Oh My Fish provides core infrastructure to allow you to install packages
      which extend or modify the look of your shell. It's fast, extensible and
      easy to use.
    '';
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "omf-install";
    inherit (fish.meta) platforms;
  };
})
# TODO: customize the omf-install script
