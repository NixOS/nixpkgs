{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  installShellFiles,
}:

stdenvNoCC.mkDerivation {
  pname = "dwt1-shell-color-scripts";
  version = "unstable-2023-03-27";

  src = fetchFromGitLab {
    owner = "dwt1";
    repo = "shell-color-scripts";
    rev = "576735cf656ece1bfd314e617b91c0e9d486d262";
    hash = "sha256-1iDcUv6uVq5LzFgZo36RRKqAzKoYKZW/MnlbneayvCY=";
  };

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    patchShebangs ./colorscript.sh
    patchShebangs ./colorscripts
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/shell-color-scripts
    install -Dm755 colorscript.sh $out/bin/colorscript
    cp -r colorscripts $out/share/shell-color-scripts/colorscripts

    installManPage colorscript.1
    installShellCompletion --fish completions/colorscript.fish
    installShellCompletion --zsh completions/_colorscript

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace \
      $out/bin/colorscript \
      $out/share/fish/vendor_completions.d/colorscript.fish \
      $out/share/zsh/site-functions/_colorscript \
      --replace-fail "/opt/shell-color-scripts/colorscripts" \
        "$out/share/shell-color-scripts/colorscripts"
  '';

  meta = {
    homepage = "https://gitlab.com/dwt1/shell-color-scripts";
    description = "Collection of shell color scripts collected by dt (Derek Taylor)";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "colorscript";
  };
}
