{
  lib,
  vscode-utils,
  jq,
  moreutils,
  texlivePackages,
}:

vscode-utils.buildVscodeMarketplaceExtension (finalAttrs: {
  mktplcRef = {
    name = "latex-utilities";
    publisher = "tecosaur";
    version = "0.4.14";
    hash = "sha256-GsbHzFcN56UbcaqFN9s+6u/KjUBn8tmks2ihK0pg3Ds=";
  };

  nativeBuildInputs = [
    jq
    moreutils
  ];

  buildInputs = [ texlivePackages.texcount ];

  postInstall = ''
    cd "$out/$installPrefix"
    echo -n ${finalAttrs.version} > VERSION
    jq '.contributes.configuration.properties."latex-utilities.countWord.path".default = "${texlivePackages.texcount}/bin/texcount"' package.json | sponge package.json
  '';

  meta = {
    description = "Add-on to the Visual Studio Code extension LaTeX Workshop";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=tecosaur.latex-utilities";
    homepage = "https://github.com/tecosaur/LaTeX-Utilities";
    changelog = "https://marketplace.visualstudio.com/items/tecosaur.latex-utilities/changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jeancaspar ];
  };
})
